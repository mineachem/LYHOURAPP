//
//  CreatePinViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/22/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard
import SwiftyJSON
import CryptoSwift

class EnterPINController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var pinTextField1: UITextField!
  @IBOutlet weak var pinTextField2: UITextField!
  @IBOutlet weak var pinTextField3: UITextField!
  @IBOutlet weak var pinTextField4: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var backButtonItem: UIBarButtonItem!
  @IBOutlet var numberPadButtons: [UIButton]!
  @IBOutlet weak var pinTextFieldHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var pinTextFieldWidthConstraint: NSLayoutConstraint!

  var textFields = [UITextField]()
  var skipOrLogoutButton: UIBarButtonItem!
  var userAuthAPI: UserAuthAPI!
  var authResponse: AuthResponse!
  var authModel: AuthViewModel!
  var isFromLoggingIn: Bool = false
  var pin = ""
  
  // MARK: Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupUI()
  }
  
  // MARK: - Action Members
  @IBAction func performOperationTapped(_ sender: UIButton) {
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count < 4 {
      guard let title = sender.currentTitle, !title.isEmpty else { return }
      pin.append(title)
      textFields[pin.count - 1].text = title
    }
    
    if sender.currentImage == #imageLiteral(resourceName: "clear-symbol") {
      if pin.count == 0 {
        return
      }
      
      _ = pin.removeLast()
      textFields[pin.count].text = ""
    }
    
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count == 4 {
      performCreatingPIN()
    }
  }
}

// MARK: - Private Members
private extension EnterPINController {
  func performCreatingPIN() {
    if UserDefaults.value(forKey: .pin) == nil {
      createPIN()
    } else {
      createPINFromLogin()
    }
  }
  
  func createPIN() {
    guard let authModel = self.authModel, let authResponse = self.authResponse else { return }
    guard let handle = authResponse.handle else { return }
    guard let timeStamp = authResponse.timeStamp else { return }
    guard let sk = authResponse.sk else { return }
    
    let credential = UpdateCredentialViewModel(isFromLoggingIn: isFromLoggingIn, authModel: authModel, authByOTP: false, deviceId: UIDevice.deviceId, handle: handle, lang: "EN", pin: pin, timeStamp: timeStamp, sk: sk)
    updateCredential(authModel: authModel, credentialModel: credential, authResponse: authResponse)
  }
  
  func createPINFromLogin() {
    if self.userAuthAPI == nil {
      self.userAuthAPI = UserAuthAPI(api: UserClientAPI())
    }
    
    guard let handle = UserDefaults.value(forKey: .handle), UserDefaults.value(forKey: .sk) != nil else { return }
    
    let authModel = AuthViewModel(deviceId: UIDevice.deviceId, handle: handle, onlyAuth: false, lang: "EN", pin: pin, timeStamp: Date.javisDateFormat)
  
    showActivityView(message: "Authenticating ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.userAuthAPI.auth(parameters: authModel.parameters) { (response, error) in
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          strongSelf.textFields.forEach({ (textField) in
            strongSelf.pin = ""
            textField.text = ""
          })
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let authResponse = response else { return }
        authModel.saveDecryptedData(withResponse: authResponse, withKey: .decryptedSk)
        
        strongSelf.checkIfNeedToShowInformationAlert {
          strongSelf.showHomeController(authModel: authModel, authResponse: authResponse)
        }
      }
    }
  }
  
  func checkIfNeedToShowInformationAlert(completion: @escaping () -> Void) {
    if UserDefaults.boolValue(forKey: .alreadyDisplayedAlertPIN) {
      completion()
    } else {
      let alertController = UIAlertController(title: "Information", message: "Please use this PIN for the next login.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        UserDefaults.set(value: true, forKey: .alreadyDisplayedAlertPIN)
        completion()
      }
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  func setupNavigationBar() {
    let title: String
    if UserDefaults.value(forKey: .sk) == nil {
      title = "SKIP"
    } else {
      title = "Sign Out"
    }
    backButtonItem.image = nil
    skipOrLogoutButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(handleSkipOrSignout))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = skipOrLogoutButton
    navigationItem.rightBarButtonItem?.tintColor = .white
  }
  
  func setupUI() {
    setupNumberPadButtons()
    setupPinTextField()
    setupClearNavigation()
    if UserDefaults.value(forKey: .sk) == nil {
      titleLabel.text = "Create 4-digit pin"
      descriptionLabel.text = "A 4 digit pin can be created to have quick access to your Wallet. If you skip this step now you may still do it later."
      skipOrLogoutButton.title = "SKIP"
    } else {
      titleLabel.text = "Enter PIN"
      descriptionLabel.text = "Enter your 4-digit PIN to login"
      skipOrLogoutButton.title = "Sign Out"
    }
    
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
      titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
      pinTextFieldHeightConstraint.constant = 50
      pinTextFieldWidthConstraint.constant = 50
    } else {
      descriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
      pinTextFieldHeightConstraint.constant = 40
      pinTextFieldWidthConstraint.constant = 40
    }
  }
  
  func setupNumberPadButtons() {
    numberPadButtons.forEach { (button) in
      button.titleLabel?.font = UIDevice.isPhone5SE ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.preferredFont(forTextStyle: .title1)
    }
  }
  
  @objc func handleSkipOrSignout() {
    if skipOrLogoutButton.title == "SKIP" {
      guard let response = authResponse, let handle = authResponse.handle, let sk = authResponse.sk, let authUser = response.user, let authModel = self.authModel else { return }
      let user = User(json: JSON(authUser))
      UserDefaults.set(value: user.preferredName ?? "Unknown", forKey: .username)
      UserDefaults.set(value: sk, forKey: .sk)
      UserDefaults.set(value: handle, forKey: .handle)
      UserDefaults.set(value: true, forKey: .skipPIN)
      
      if let previousSk = UserDefaults.bytes(forKey: .decryptedSk) {
        let decryptedSkKey = previousSk.toHexString().uppercased().toHex64String.hexStringToBytes() ?? []
        let bytesSk = sk.base64StringToByteArray() ?? []
        let bytesHandle = handle.base64StringToByteArray() ?? []
        guard let decryptedLoginSk = JARVISViewModelUtils.decrypt(values: bytesSk, withKey: decryptedSkKey, withIv: bytesHandle) else { return }
        UserDefaults.set(bytes: decryptedLoginSk, forKey: .decryptedLoginSk)
        UserDefaults.set(bytes: bytesHandle, forKey: .byteHandle)
      }
      
      let alertController = UIAlertController(title: "Information", message: "Please use your username and password for the next login", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
        guard let strongSelf = self else { return }
        strongSelf.showHomeController(authModel: authModel, authResponse: strongSelf.authResponse)
      }
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
    } else {
      signOut(from: self)
    }
  }
  
  func updateCredential(authModel: AuthViewModel, credentialModel: UpdateCredentialViewModel, authResponse: AuthResponse) {
    showActivityView(message: "Creating PIN ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      self?.userAuthAPI.updateCredential(parameters: credentialModel.parameters) { (error) in
        if let err = error {
          self?.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          self?.textFields.forEach { (textField) in
            self?.pin = ""
            textField.text = ""
          }
          return
        }
        
        self?.stopAnimating(nil)
        UserDefaults.set(value: "Pin", forKey: .pin)
        UserDefaults.set(value: credentialModel.sk, forKey: .sk)
        UserDefaults.set(value: credentialModel.handle, forKey: .handle)
        
        self?.checkIfNeedToShowInformationAlert {
          self?.showHomeController(authModel: authModel, authResponse: authResponse)
        }
      }
    }
  }
  
  func setupPinTextField() {
    textFields = [pinTextField1, pinTextField2, pinTextField3, pinTextField4]
    textFields.forEach { (textField) in
      textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
      textField.isSecureTextEntry = true
      if UIDevice.isBiggestPhone {
        textField.font = UIFont.boldSystemFont(ofSize: 24)
      } else {
        textField.font = UIFont.boldSystemFont(ofSize: 16)
      }
    }
  }
}
