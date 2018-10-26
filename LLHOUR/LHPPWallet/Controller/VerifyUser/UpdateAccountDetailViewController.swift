//
//  UpdateAccountDetailViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion

class UpdateAccountDetailViewController: UIViewController {
  @IBOutlet weak var firstNameTextField: TextField!
  @IBOutlet weak var lastNameTextField: TextField!
  @IBOutlet weak var nickNameTextField: TextField!
  @IBOutlet weak var emailTextField: TextField!
  @IBOutlet weak var dateOfbirthTextField: TextField!
  @IBOutlet weak var maleRadioBtn: UIButton!
  @IBOutlet weak var femaleRadioBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextField()
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func setupTextField() {
    firstNameTextField.dividerNormalColor = UIColor.gray
    
    firstNameTextField.dividerActiveColor = UIColor.gray
    
    firstNameTextField.placeholderNormalColor = .gray
    firstNameTextField.placeholderActiveColor = .gray
    
    lastNameTextField.dividerNormalColor = UIColor.gray
    lastNameTextField.dividerActiveColor = UIColor.gray
    lastNameTextField.placeholderNormalColor = .gray
    lastNameTextField.placeholderActiveColor =  .gray
    
    nickNameTextField.dividerNormalColor = UIColor.gray
    nickNameTextField.dividerActiveColor = UIColor.gray
    nickNameTextField.placeholderNormalColor = .gray
    nickNameTextField.placeholderActiveColor = .gray
    
    emailTextField.dividerNormalColor = UIColor.gray
    emailTextField.dividerActiveColor = UIColor.gray
    emailTextField.placeholderNormalColor = .gray
    emailTextField.placeholderActiveColor = .gray
    
    dateOfbirthTextField.dividerNormalColor = .clear
    dateOfbirthTextField.dividerActiveColor = .clear
    dateOfbirthTextField.placeholderActiveColor = .gray
    dateOfbirthTextField.placeholderNormalColor = .gray
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
  }
  
  @IBAction func doneTapped(_ sender: RoundButton) {
    
  }
  
}

extension UpdateAccountDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
