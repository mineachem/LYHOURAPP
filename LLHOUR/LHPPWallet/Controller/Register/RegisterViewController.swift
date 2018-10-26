//
//  RegisterViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
import SwinjectStoryboard

class RegisterViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var fullNameTextField: TextField!
  @IBOutlet weak var userNameTextField: TextField!
  @IBOutlet weak var passwordTextField: TextField!
  @IBOutlet weak var dateOfbirthTextField: TextField!
  @IBOutlet weak var bottomlineFullName: UIView!
  @IBOutlet weak var bottomlineUsername: UIView!
  @IBOutlet weak var bottomlinePassword: UIView!
  @IBOutlet weak var bottomlineDOB: UIView!
  @IBOutlet weak var maleRadioButton: RadioButton!
  @IBOutlet weak var femaleRadioButton: RadioButton!
  
  @IBOutlet weak var logoImageViewTopLayoutContraint: NSLayoutConstraint! {
    didSet {
      logoImageViewTopLayoutContraint.constant = UIDevice.isPhone5SE ? -12 : 0
    }
  }
  
  @IBOutlet weak var registerStackView: UIStackView! {
    didSet {
      registerStackView.spacing = UIDevice.isPhone5SE ? 25 : 40
    }
  }
  
  @IBOutlet weak var maleLabel: UILabel!
  @IBOutlet weak var femaleLabel: UILabel!
  
  var challengeJarvis: ChallengeViewModel!
  var jarvisChallengeResponse: ChallengeResponse!
  var userAuthAPI: UserAuthAPI!
  var datePicker = UIDatePicker()
  var gender = ""
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  deinit {
    removeKeyboardNotification()
  }
  
  // MARK: Action Members
  @IBAction func maleButtonTapped(_ sender: RadioButton) {
    setupRadioButton(sender, isSelected: true)
  }
  
  @IBAction func femaleButtonTapped(_ sender: RadioButton) {
    setupRadioButton(sender, isSelected: true)
  }
  
  @IBAction func registerButtonTapped(_ sender: UIButton) {
    if fullNameTextField.text!.isEmpty || userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || dateOfbirthTextField.text!.isEmpty {
      alertMessage(title: "Error", message: "All fields are mandatory. Please enter all required information.", on: self)
      return
    }
    
    if userNameTextField.text!.count < 4 {
      alertMessage(title: "Error", message: "Username should have at least 4 character longs", on: self)
      return
    }
    
    register(with: fullNameTextField.text!.trimWhiteSpaces(), userName: userNameTextField.text!.trimWhiteSpaces(), password: passwordTextField.text!, dateOfBirth: dateOfbirthTextField.text!)
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
}

// MARK: - Private Members
private extension RegisterViewController {
  func register(with fullName: String, userName: String, password: String, dateOfBirth: String) {
    guard let challengeJarvis = self.challengeJarvis, let jarvisChallengeResponse = self.jarvisChallengeResponse else { return }
    guard let fk = jarvisChallengeResponse.fk else { return }
    guard let handle = jarvisChallengeResponse.handle else { return }
    guard let timeStamp = jarvisChallengeResponse.timeStamp else { return }
    
    let fullName = Name(fullName: fullName)
    
    let registerModel = RegisterViewModel(challengeKey: challengeJarvis, fk: fk, deviceId: challengeJarvis.deviceId, handle: handle, lang: "EN", fullName: fullName, preferredName: userName, gender: gender, dob: dateOfBirth, userName: userName, userPass: password, type: 0, timeStamp: timeStamp)
    
    showActivityView(message: "Creating Account ...", messageColor: .white) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.userAuthAPI.register(parameters: registerModel.parameters, completion: { [weak self] (values, error) in
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          return
        }
        
        guard let jarvisRegisterResponse = values else { return }
        self?.auth(model: registerModel, registerResponse: jarvisRegisterResponse)
      })
    }
  }
  
  func auth(model: RegisterViewModel, registerResponse: RegisterResponse) {
    let jarvisAuth = AuthViewModel(registerResponse: registerResponse,
                                          registerModel: model,
                                          deviceId: model.deviceId,
                                          handle: registerResponse.handle ?? "",
                                          onlyAuth: false,
                                          lang: model.lang,
                                          pin: "",
                                          userName: model.userName,
                                          userPass: model.userPass,
                                          timeStamp: registerResponse.timeStamp ?? "")
    userAuthAPI.auth(parameters: jarvisAuth.parameters, completion: { [weak self] (values, error) in
      if let err = error, let strongSelf = self {
        strongSelf.stopAnimating(nil)
        alertMessage(title: "Error", message: err, on: strongSelf)
        return
      }
      
      self?.stopAnimating(nil)
      guard let response = values else { return }
      self?.showCreatePinController(with: jarvisAuth, response: response)
    })
  }
  
  func showCreatePinController(with authModel: AuthViewModel, response: AuthResponse) {
    guard let createPinController = SwinjectStoryboard.initController(withIdentifier: ControllerName.enterPin.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? EnterPINController else { return }
    createPinController.authResponse = response
    createPinController.authModel = authModel
    navigationController?.pushViewController(createPinController, animated: true)
    UserDefaults.set(value: true, forKey: .fromRegister)
  }
  
  func setupUI() {
    setupTextFieldMaterial()
    setupClearNavigation()
    setupDatePicker()
    setupRadioButton(maleRadioButton, isSelected: true)
    
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      maleLabel.font = UIFont.preferredFont(forTextStyle: .body)
      femaleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    } else {
      maleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      femaleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    maleLabel.isUserInteractionEnabled = true
    femaleLabel.isUserInteractionEnabled = true
    maleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaleButtonPressed)))
    femaleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFemaleButtonPressed)))
  }
  
  @objc func handleMaleButtonPressed() {
    maleButtonTapped(maleRadioButton)
  }
  
  @objc func handleFemaleButtonPressed() {
    femaleButtonTapped(femaleRadioButton)
  }
  
  @objc func setupRadioButton(_ radioButton: RadioButton, isSelected: Bool) {
    if radioButton == maleRadioButton {
      gender = "M"
      femaleRadioButton.isSelected = !isSelected
      maleRadioButton.isSelected = isSelected
    } else {
      gender = "F"
      maleRadioButton.isSelected = !isSelected
      femaleRadioButton.isSelected = isSelected
    }
  }
  
  func setupDatePicker() {
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
    let toolbar = UIToolbar()
    toolbar.initToolBar(with: doneButton)
    dateOfbirthTextField.inputAccessoryView = toolbar
    dateOfbirthTextField.inputView = datePicker
    datePicker.datePickerMode = .date
  }
  
  @objc func doneClick() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MMM/yyyy"
    let selectedDate = dateFormatter.string(from: datePicker.date)
    dateOfbirthTextField.text = selectedDate
    dateOfbirthTextField.resignFirstResponder()
  }
  
  func setupTextFieldMaterial() {
    let textFields: [TextField] = [fullNameTextField, userNameTextField, passwordTextField, dateOfbirthTextField]
    textFields.forEach { (textField) in
      textField.placeholderNormalColor = .white
      textField.placeholderActiveColor = .white
      textField.dividerActiveColor = .clear
      textField.dividerNormalColor = .clear
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
  
    bottomlineFullName.backgroundColor = .gray
    bottomlineUsername.backgroundColor = .gray
    bottomlinePassword.backgroundColor = .gray
    bottomlineDOB.backgroundColor = .gray
    
    passwordTextField.visibilityIconOn = UIImage(named: "eye-64")
    passwordTextField.visibilityIconOff = UIImage(named: "hide-64")
  }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case fullNameTextField:
      _ = userNameTextField.becomeFirstResponder()
    case userNameTextField:
      _ = passwordTextField.becomeFirstResponder()
    case passwordTextField:
      _ = dateOfbirthTextField.becomeFirstResponder()
    default:
      textField.resignFirstResponder()
    }
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == dateOfbirthTextField {
      return false
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    switch textField {
    case fullNameTextField:
      if bottomlineFullName.backgroundColor == .gray {
        bottomlineFullName.backgroundColor = .white
      }
    case userNameTextField:
      if bottomlineUsername.backgroundColor == .gray {
        bottomlineUsername.backgroundColor = .white
      }
    case passwordTextField:
      if bottomlinePassword.backgroundColor == .gray {
        bottomlinePassword.backgroundColor = .white
      }
    case dateOfbirthTextField:
      if bottomlineDOB.backgroundColor == .gray {
        bottomlineDOB.backgroundColor = .white
      }
    default:
      break
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
    case fullNameTextField:
      if bottomlineFullName.backgroundColor == .white {
        bottomlineFullName.backgroundColor = .gray
      }
    case userNameTextField:
      if bottomlineUsername.backgroundColor == .white {
        bottomlineUsername.backgroundColor = .gray
      }
    case passwordTextField:
      if bottomlinePassword.backgroundColor == .white {
        bottomlinePassword.backgroundColor = .gray
      }
    case dateOfbirthTextField:
      if bottomlineDOB.backgroundColor == .white {
        bottomlineDOB.backgroundColor = .gray
      }
    default:
      break
    }
  }
}
