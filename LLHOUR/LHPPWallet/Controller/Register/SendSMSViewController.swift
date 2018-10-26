//
//  SendSMSViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
import PhoneNumberKit
import SwinjectStoryboard

class SendSMSViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var mobileNumberTextField: PhoneNumberTextField!
  @IBOutlet weak var nextVerificaton: RoundButton!
  @IBOutlet weak var phoneDescriptionLabel: UILabel!
  @IBOutlet weak var nextButtonHeightContraint: NSLayoutConstraint!
  @IBOutlet weak var nextButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var nextButton: RoundButton!
  
  private var datePicker: UIPickerView?
  var userAuthAPI: UserAuthAPI!
  private var initModel: InitViewModel!
  
  private enum CountryCode: Int {
    case cambodia = 855
    case thailand = 66
  }
  
  //contryname
  private let contryCodeName = ["Cambodia (+855)", "Thailand (+66)"]
  private var code: CountryCode = .cambodia
  
  //Picker View
  private let countryCodePickerView = UIPickerView()
  
  // that Hold current data
  private var countryCodeStrings: [String] = []
  
  //that hold current text field
  private var activeTextField: UITextField!
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  deinit {
    removeKeyboardNotification()
  }
  
  // MARK: - Action Members
  @IBAction func back_sendSMS(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Private Members
private extension SendSMSViewController {
  func setupUI() {
    nextVerificaton.addTarget(self, action: #selector(verificationTapped), for: .touchUpInside)
    mobileNumberTextField.delegate = self
    countryCodeTextField.delegate = self
    countryCodePickerView.delegate = self
    countryCodePickerView.dataSource = self
    
    countryCodeTextField.inputView = countryCodePickerView
    setupTextField()
    createToolBar()
    setupClearNavigation()
    
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      countryCodeTextField.font = UIFont.preferredFont(forTextStyle: .body)
      mobileNumberTextField.font = UIFont.preferredFont(forTextStyle: .body)
      phoneDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      nextButton.cornerRadius = 30
      nextButtonHeightContraint.constant = 60
      nextButtonWidthConstraint.constant = 60
    } else {
      countryCodeTextField.font = UIFont.preferredFont(forTextStyle: .callout)
      mobileNumberTextField.font = UIFont.preferredFont(forTextStyle: .callout)
      phoneDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
      nextButton.cornerRadius = 25
      nextButtonHeightContraint.constant = 50
      nextButtonWidthConstraint.constant = 50
    }
  }
  
  @objc func verificationTapped(_ sender: RoundButton) {
    handleJarvisInit()
  }
  
  func setupTextField() {
    countryCodeTextField.addLine(to: .bottom, color: .lightGray, width: 0.75)
    mobileNumberTextField.addLine(to: .bottom, color: .lightGray, width: 0.75)
  }
  
  // create a toolbar
  func createToolBar() {
    let countryDoneButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextClick))
    let countryToolbar = UIToolbar()
    countryToolbar.initToolBar(with: countryDoneButton)
    countryCodeTextField.inputAccessoryView = countryToolbar
    
    let phoneDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleJarvisInit))
    let phoneToolbar = UIToolbar()
    phoneToolbar.initToolBar(with: phoneDoneButton)
    mobileNumberTextField.inputAccessoryView = phoneToolbar
  }
  
  @objc func nextClick() {
    _ = mobileNumberTextField.becomeFirstResponder()
  }
  
  @objc func handleJarvisInit() {
    mobileNumberTextField.resignFirstResponder()
    if mobileNumberTextField.text!.isEmpty {
      alertMessage(title: "Error", message: "Phone Number is required. Please enter your phone number.", on: self) { (_) in
        _ = self.mobileNumberTextField.becomeFirstResponder()
      }
      return
    }
    
    let convertedMobileNumber = mobileNumberTextField.text!.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)

    if convertedMobileNumber.count >= 9 {
      guard let mobileNumber = Int(convertedMobileNumber) else { return }
      initModel = InitViewModel(deviceId: UIDevice.deviceId, countryCode: code.rawValue, mobile: mobileNumber, lang: "EN", program: "INC", timeStamp: Date.javisDateFormat)
      initJarvis(with: initModel)
    } else {
      alertMessage(title: "Error", message: "Phone Number should have 9 digits.", on: self) { (_) in
        _ = self.mobileNumberTextField.becomeFirstResponder()
      }
    }
  }
  
  func initJarvis(with initModel: InitViewModel) {
    showActivityView(message: "Sending Verification Code ...", messageColor: .white, minimumDisplayTime: 2) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.userAuthAPI.initJARVIS(with: initModel.parameters) { [weak self] (values, error) in
        if let err = error {
          strongSelf.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          return
        }
        
        strongSelf.stopAnimating(nil)
        guard let response = values else { return }
        guard let verificationController = SwinjectStoryboard.initController(withIdentifier: ControllerName.verification.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? VerificationViewController else { return }
        verificationController.initModel = self?.initModel
        verificationController.initResponse = response
        strongSelf.navigationController?.pushViewController(verificationController, animated: true)
      }
    }
  }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension SendSMSViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return countryCodeStrings.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return countryCodeStrings[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    print("Selected item is", countryCodeStrings[row])
    activeTextField.text = countryCodeStrings[row]
  }
}

// MARK: - UITextFieldDelegate
extension SendSMSViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    activeTextField = textField
    
    switch textField {
    case countryCodeTextField:
      countryCodeStrings = contryCodeName
      mobileNumberTextField.removeLineConstraints()
      mobileNumberTextField.addLine(to: .bottom, color: .lightGray, width: 0.75)
      
      countryCodeTextField.removeLineConstraints()
      countryCodeTextField.addLine(to: .bottom, color: .gray, width: 1)
    default:
      countryCodeTextField.removeLineConstraints()
      countryCodeTextField.addLine(to: .bottom, color: .lightGray, width: 0.75)
      
      mobileNumberTextField.removeLineConstraints()
      mobileNumberTextField.addLine(to: .bottom, color: .gray, width: 1)
    }
    countryCodePickerView.reloadAllComponents()
    return true
  }
  
  // Prevent from entering Texts
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == countryCodeTextField {
      return false
    }
    
    // return true if the replacementString only contains numeric characters
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
}
