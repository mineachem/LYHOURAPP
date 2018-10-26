//
//  DigitViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion

class DigitTableViewController: UITableViewController {
  
  // MARK: - Properties
  @IBOutlet weak var OTP1TextField: UITextField!
  @IBOutlet weak var OTP2TextField: UITextField!
  @IBOutlet weak var OTP3TextField: UITextField!
  @IBOutlet weak var iconCheckImageView: UIImageView!
  @IBOutlet weak var signLabel: UILabel!
  @IBOutlet weak var pricesLabel: UILabel!
  @IBOutlet weak var titlePricesLabel: UILabel!
  
  var transactionAPI: TransactionAPI!
  
  // MARK: Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    OTP1TextField.delegate = self
    OTP2TextField.delegate = self
    OTP3TextField.delegate = self
  }
  
  // MARK: UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

extension DigitTableViewController: UITextFieldDelegate {
  //swiftlint:disable cyclomatic_complexity
  //swiftlint:disable function_body_length
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let textstring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    let length = textstring.count
    
    if (length < 1) && (string.count > 0) {
      if textField == OTP1TextField {
        OTP2TextField.becomeFirstResponder()
      }
      
      if textField == OTP2TextField {
        OTP3TextField.becomeFirstResponder()
      }
      
      if textField == OTP3TextField {
        OTP3TextField.resignFirstResponder()
      }
      textField.text = textstring
      return false
    } else if (length <= 0) && (string.count == 0) {
      if textField == OTP2TextField {
        OTP1TextField.becomeFirstResponder()
        signLabel.alpha = 0
        iconCheckImageView.alpha = 1
        pricesLabel.alpha = 1
        titlePricesLabel.alpha = 1
      }
      if textField == OTP3TextField {
        OTP2TextField.becomeFirstResponder()
        signLabel.alpha = 0
        iconCheckImageView.alpha = 1
        pricesLabel.alpha = 1
        titlePricesLabel.alpha = 1
      }
      
      if textField == OTP1TextField {
        OTP1TextField.resignFirstResponder()
        signLabel.alpha = 1
        iconCheckImageView.alpha = 0
        pricesLabel.alpha = 0
        titlePricesLabel.alpha = 0
      }
      
      textField.text = ""
      return false
      
    } else if length == 3 && length < 4 {
      if textField == OTP1TextField {
        OTP2TextField.becomeFirstResponder()
        signLabel.alpha = 1
        iconCheckImageView.alpha = 0
        pricesLabel.alpha = 0
        titlePricesLabel.alpha = 0
      }
      
      if textField == OTP2TextField {
        OTP3TextField.becomeFirstResponder()
        signLabel.alpha = 1
        iconCheckImageView.alpha = 0
        pricesLabel.alpha = 0
        titlePricesLabel.alpha = 0
      }
      
      if textField == OTP3TextField {
        OTP3TextField.resignFirstResponder()
        signLabel.alpha = 0
        iconCheckImageView.alpha = 1
        pricesLabel.alpha = 1
        titlePricesLabel.alpha = 1
      }
      textField.text = textstring
      return false
    }
    return true
  }
}
