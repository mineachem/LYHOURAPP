//
//  AccountDetailViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/14/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
class AccountDetailViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var firstNameTextField: TextField!
  @IBOutlet weak var lastNameTextField: TextField!
  
  @IBOutlet weak var nicknameTextField: TextField!
  
  @IBOutlet weak var emailTextField: TextField!
  @IBOutlet weak var dateOfbirth: TextField!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var femaleBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextField()
    setupClearNavigation()
    navigationItem.title = "Account Details"
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func setupTextField() {
    firstNameTextField.dividerNormalColor = .gray
    firstNameTextField.dividerActiveColor = .gray
    firstNameTextField.placeholderNormalColor = .gray
    firstNameTextField.placeholderActiveColor = .gray
    
    lastNameTextField.dividerNormalColor = .gray
    lastNameTextField.dividerActiveColor = .gray
    lastNameTextField.placeholderNormalColor = .gray
    lastNameTextField.placeholderActiveColor = .gray
    
    nicknameTextField.dividerNormalColor = .gray
    nicknameTextField.dividerActiveColor = .gray
    nicknameTextField.placeholderNormalColor = .gray
    nicknameTextField.placeholderActiveColor = .gray
    
    emailTextField.dividerNormalColor = .gray
    emailTextField.dividerActiveColor = .gray
    emailTextField.placeholderNormalColor = .gray
    emailTextField.placeholderActiveColor = .gray
    
    dateOfbirth.dividerNormalColor = UIColor.clear
    dateOfbirth.dividerActiveColor = UIColor.clear
    dateOfbirth.placeholderNormalColor = .gray
    dateOfbirth.placeholderActiveColor = .gray
  }
  
  @IBAction func doneTapped(_ sender: UIButton) {
    
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
}

extension AccountDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
