//
//  ViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
import SwinjectStoryboard

class LoginPasswordViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var bottomLineUsername: UIView!
  @IBOutlet weak var bottomLinePassword: UIView!
  @IBOutlet weak var usernameTextField: TextField!
  @IBOutlet weak var passwordTextField: TextField!
  @IBOutlet weak var createOneButton: UIButton!
  @IBOutlet weak var nextButton: RoundButton!
  @IBOutlet weak var nextButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var textfieldCollectionStackView: UIStackView!
  @IBOutlet weak var forgotPasswordBottomContraint: NSLayoutConstraint!
  @IBOutlet weak var noAccountYetLabel: UILabel!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var userAuthAPI: UserAuthAPI!
  var savedUsername: String!
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    setupTextFieldMaterial()
    setupClearNavigation()
    noAccountYetLabel.detailStyle()
    forgotPasswordButton.configureStyle()
    let yourAttributes : [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.foregroundColor : UIColor.white,
      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    let attributeString = NSMutableAttributedString(string: "Create one", attributes: yourAttributes)
    createOneButton.setAttributedTitle(attributeString, for: .normal)
    createOneButton.configureStyle()
    
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      textfieldCollectionStackView.spacing = 40
      forgotPasswordBottomContraint.constant = 60
      nextButton.cornerRadius = 30
      nextButtonWidthConstraint.constant = 60
      nextButtonHeightConstraint.constant = 60
    } else {
      textfieldCollectionStackView.spacing = 20
      forgotPasswordBottomContraint.constant = 30
      nextButton.cornerRadius = 25
      nextButtonWidthConstraint.constant = 50
      nextButtonHeightConstraint.constant = 50
    }
  }
  
  deinit {
    removeKeyboardNotification()
  }
  
  // MARK: - Action Members
  @IBAction func nextPage(_ sender: RoundButton) {
    performLogin()
  }
  
  @IBAction func createAccountTapped(_ sender: UIButton) {
    let sendSMSController = SwinjectStoryboard.initController(withIdentifier: ControllerName.sendSMS.rawValue, fromStoryboard: StoryboardName.register.rawValue)
    navigationController?.pushViewController(sendSMSController, animated: true)
  }
  
  @IBAction func forgot_password(_ sender: UIButton) {
    let resetPasswordController = SwinjectStoryboard.initController(withIdentifier: ControllerName.resetPassword.rawValue, fromStoryboard: StoryboardName.register.rawValue)
    navigationController?.pushViewController(resetPasswordController, animated: true)
  }
}

// MARK: - Private Members
private extension LoginPasswordViewController {
  func performLogin() {
    if checkIfAllInfoAreValid() {
      guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
      if username.trimWhiteSpaces() == savedUsername {
        loginUserWithNoPIN(username: savedUsername, password: password)
      } else {
        login(username: username.trimWhiteSpaces(), password: password)
        UserDefaults.set(value: false, forKey: .skipPIN)
      }
      view.endEditing(true)
    }
  }
  
  func login(username: String, password: String) {
    showActivityView(message: "Authenticating ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      
      let initModel = InitViewModel(deviceId: UIDevice.deviceId, userName: username, lang: "EN", program: "INC", timeStamp: Date.javisDateFormat)
      strongSelf.userAuthAPI.initJARVIS(with: initModel.parameters) { (initResponse, error) in
        
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let response = initResponse else { return }
        strongSelf.showVerificationScreen(initResponse: response, username: username, password: password)
      }
    }
  }
  
  func loginUserWithNoPIN(username: String, password: String) {
    showActivityView(message: "Authenticating ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      guard let username = strongSelf.usernameTextField.text, let userPass = strongSelf.passwordTextField.text else { return }
      
      guard let handle = UserDefaults.value(forKey: .handle) else { return }
      let authModel = AuthViewModel(deviceId: UIDevice.deviceId, handle: handle, onlyAuth: false, lang: "EN", userName: username, userPass: userPass, timeStamp: Date.javisDateFormat)
      strongSelf.userAuthAPI.auth(parameters: authModel.parameters, completion: { (response, error) in
        if let err = error {
          strongSelf.stopAnimating()
          alertMessage(title: "Error", message: err, on: strongSelf)
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let authResponse = response else { return }
        strongSelf.showHomeController(authModel: authModel, authResponse: authResponse)
        authModel.saveDecryptedData(withResponse: authResponse, withKey: .decryptedLoginSk)
      })
    }
  }
  
  func showVerificationScreen(initResponse: InitResponse, username: String, password: String) {
    guard let verificationController = SwinjectStoryboard.initController(withIdentifier: ControllerName.verification.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? VerificationViewController else { return }
    verificationController.initResponse = initResponse
    verificationController.isFromLoggedIn = true
    verificationController.userName = username
    verificationController.userPass = password
    navigationController?.pushViewController(verificationController, animated: true)
  }
  
  func setupTextFieldMaterial() {
    let textFields: [TextField] = [usernameTextField, passwordTextField]
    textFields.forEach { (textField) in
      textField.placeholderNormalColor = .white
      textField.placeholderActiveColor = .white
      textField.dividerNormalColor = .clear
      textField.dividerActiveColor = .clear
      textField.textColor = .white
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        textField.detailLabel.fontSize = 14.0
        textField.font = UIFont.preferredFont(forTextStyle: .body)
      } else if UIDevice.isPhone678 {
        textField.detailLabel.fontSize = 13.0
      } else if UIDevice.isPhone5SE {
        textField.detailLabel.fontSize = 12.0
      }
    }
    
    bottomLineUsername.backgroundColor = .gray
    bottomLinePassword.backgroundColor = .gray
    passwordTextField.visibilityIconOff = UIImage(named: "hide-64")
    passwordTextField.visibilityIconOn = UIImage(named: "eye-64")
    
    if savedUsername != nil {
      usernameTextField.text = savedUsername
    }
  }
  
  func checkIfAllInfoAreValid() -> Bool {
    if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      alertMessage(title: "Error", message: "All fields are mandatory. Please enter all required information.", on: self)
      return false
    }
    return true
  }
}

// MARK: - UITextFieldDelegate
extension LoginPasswordViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case usernameTextField:
      _ = passwordTextField.becomeFirstResponder()
    case passwordTextField:
      passwordTextField.resignFirstResponder()
      performLogin()
    default:
      textField.resignFirstResponder()
    }
    return false
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    switch textField {
    case usernameTextField:
      if self.bottomLineUsername.backgroundColor == .gray {
        bottomLineUsername.backgroundColor = .white
      }
    case passwordTextField:
      if self.bottomLinePassword.backgroundColor == .gray {
        bottomLinePassword.backgroundColor = .white
      }
    default:
      break
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
    case usernameTextField:
      if self.bottomLineUsername.backgroundColor == .white {
        bottomLineUsername.backgroundColor = .gray
      }
    case passwordTextField:
      if self.bottomLinePassword.backgroundColor == .white {
        bottomLinePassword.backgroundColor = .gray
      }
    default:
      break
    }
  }
}
