//
//  VerificationViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwinjectStoryboard

class VerificationViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var verificationOtpTextField1: UITextField!
  @IBOutlet weak var verificationOtpTextField2: UITextField!
  @IBOutlet weak var verificationOtpTextField3: UITextField!
  @IBOutlet weak var verificationOtpTextField4: UITextField!
  @IBOutlet weak var verificationOtpTextField5: UITextField!
  @IBOutlet weak var verificationOtpTextField6: UITextField!
  @IBOutlet weak var verificationTitleLabel: UILabel!
  @IBOutlet weak var verificationLabel: UILabel!
  @IBOutlet var numberPadButtons: [UIButton]!
  @IBOutlet weak var otpTextFieldWidthContraint: NSLayoutConstraint!
  @IBOutlet weak var otpTextFieldHeightContraint: NSLayoutConstraint!
  
  var userIsInTheMiddleOfTyping = false
  var userAuthAPI: UserAuthAPI!
  var initModel: InitViewModel?
  var initResponse: InitResponse!
  var isFromLoggedIn = false
  var pin = ""
  var userName: String!
  var userPass: String!
  var textFields = [UITextField]()
  
  // MARK: Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textFields.forEach { (textField) in
      textField.text = ""
      pin = ""
    }
  }
  
  // MARK: Action Members
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func performOperationTapped(_ sender: UIButton) {
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count < 6 {
      guard let title = sender.currentTitle, !title.isEmpty else { return }
      pin.append(title)
      print(pin)
      textFields[pin.count - 1].text = title
    }
    
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count == 6 {
      guard let pinCode = Int(pin) else { return }
      verify(with: pinCode)
      return
    }
    
    if sender.currentImage == #imageLiteral(resourceName: "clear-symbol") {
      if pin.count == 0 {
        return
      }
      
      let removePin = pin.removeLast()
      textFields[pin.count].text = ""
      print("Pin: \(pin)\nremovePin: \(removePin)")
    }
  }
  
}

// MARK: - Private Members
private extension VerificationViewController {
  func verify(with otp: Int) {
    guard let initResponse = self.initResponse, let ik = initResponse.ik, let crp = initResponse.crp, let handle = initResponse.handle, let timeStamp = initResponse.timeStamp else { return }
    
    let challengeModel: ChallengeViewModel
    
    if isFromLoggedIn {
      guard let lang = initResponse.lang else { return }
      guard let additional = initResponse.additional else { return }
      let json = JSON(additional)
      guard let mobileString = json.dictionary?["_mobile"]?.string, let mobile = Int(mobileString) else { return }
      guard let countryCodeString = json.dictionary?["_countryCode"]?.string, let countryCode = Int(countryCodeString) else { return }
      
      challengeModel = ChallengeViewModel(deviceId: UIDevice.deviceId, otp: otp, countryCode: countryCode, mobile: mobile, crp: crp, ik: ik, handle: handle, lang: lang, timeStamp: timeStamp)
      
      challenge(model: challengeModel)
      
    } else {
      guard let initJarvis = self.initModel else { return }
      challengeModel = ChallengeViewModel(deviceId: initJarvis.deviceId, otp: otp, countryCode: initJarvis.countryCode, mobile: initJarvis.mobile, crp: crp, ik: ik, handle: handle, lang: "EN", timeStamp: timeStamp)
      
      challenge(model: challengeModel)
    }
  }
  
  func challenge(model: ChallengeViewModel) {
    showActivityView(message: "Verifying ...", messageColor: .white, minimumDisplayTime: 2) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.userAuthAPI.challenge(parameters: model.parameters) { [weak self] (values, error) in
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          strongSelf.pin = ""
          strongSelf.textFields.forEach({ (textField) in
            textField.text = ""
          })
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let challengeResponse = values else { return }
        if strongSelf.isFromLoggedIn {
          guard let userName = self?.userName, let userPass = self?.userPass else { return }
          strongSelf.loginChallenge(with: model, challengeResponse: challengeResponse, userName: userName, userPass: userPass)
        } else {
          guard let registerController = SwinjectStoryboard.initController(withIdentifier: ControllerName.register.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? RegisterViewController else { return }
          registerController.challengeJarvis = model
          registerController.jarvisChallengeResponse = challengeResponse
          self?.navigationController?.pushViewController(registerController, animated: true)
        }
      }
    }
  }
  
  func loginChallenge(with model: ChallengeViewModel, challengeResponse: ChallengeResponse, userName: String, userPass: String) {
    guard let handle = challengeResponse.handle else { return }
    guard let sk = challengeResponse.sk else { return }
    guard let lang = challengeResponse.lang else { return }
    guard let timeStamp = challengeResponse.timeStamp else { return }
    
    let loginAuth = AuthViewModel(challengeModel: model, challengeResponse: challengeResponse, challengeSk: sk, deviceId: UIDevice.deviceId, handle: handle, onlyAuth: false, lang: lang, otp: model.otp, userName: userName, userPass: userPass, timeStamp: timeStamp)
    UserDefaults.set(value: userName, forKey: .username)
    auth(model: loginAuth)
  }
  
  func auth(model: AuthViewModel) {
    showActivityView(message: "Verifying ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.userAuthAPI.auth(parameters: model.parameters, completion: { (response, error) in
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          strongSelf.pin = ""
          strongSelf.textFields.forEach({ (textField) in
            textField.text = ""
          })
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let authResponse = response else { return }
        guard let createPinController = SwinjectStoryboard.initController(withIdentifier: ControllerName.enterPin.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? EnterPINController else { return }
        createPinController.authModel = model
        createPinController.authResponse = authResponse
        createPinController.isFromLoggingIn = strongSelf.isFromLoggedIn
        strongSelf.navigationController?.pushViewController(createPinController, animated: true)

        guard let sk = authResponse.sk, let handle = authResponse.handle else { return }
        UserDefaults.set(value: sk, forKey: .sk)
        UserDefaults.set(value: handle, forKey: .handle)
      })
    }
  }
  
  func setupUI() {
    setupPinTextField()
    setupNumberPadButtons()
    
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      otpTextFieldWidthContraint.constant = 50
      otpTextFieldHeightContraint.constant = 50
      verificationTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
      verificationLabel.font = UIFont.preferredFont(forTextStyle: .body)
    } else {
      otpTextFieldWidthContraint.constant = 40
      otpTextFieldHeightContraint.constant = 40
      verificationTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
      verificationLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    guard let mobileNumber = initModel?.mobile else { return }
    verificationLabel.text = "Please type the verification code sent  to +855 \(mobileNumber)"
  }
  
  func setupNumberPadButtons() {
    numberPadButtons.forEach { (button) in
      button.titleLabel?.font = UIDevice.isPhone5SE ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.preferredFont(forTextStyle: .title1)
    }
  }
  
  func setupPinTextField() {
    textFields = [verificationOtpTextField1, verificationOtpTextField2, verificationOtpTextField3, verificationOtpTextField4, verificationOtpTextField5, verificationOtpTextField6]
    textFields.forEach { (textField) in
      textField.isSecureTextEntry = true
      textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
      if UIDevice.isBiggestPhone {
        textField.font = UIFont.boldSystemFont(ofSize: 24)
      } else {
        textField.font = UIFont.boldSystemFont(ofSize: 16)
      }
    }
    verificationOtpTextField1.becomeFirstResponder()
  }
}
