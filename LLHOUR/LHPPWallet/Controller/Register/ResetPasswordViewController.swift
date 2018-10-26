//
//  ResetPasswordViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/10/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
class ResetPasswordViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var newPasswordTextField: TextField!
  @IBOutlet weak var confirmPassword: TextField!
  
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
    let textFields: [TextField] = [newPasswordTextField, confirmPassword]
    textFields.forEach { (textField) in
      textField.dividerNormalColor = .clear
      textField.dividerActiveColor = . clear
      textField.placeholderNormalColor = .gray
      textField.placeholderActiveColor = .gray
    }
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func resetPasswordTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "resetPassword", sender: self)
  }
}

extension ResetPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
