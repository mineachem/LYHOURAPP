//
//  CreateTransactionPINViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/6/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class CreateTransactionPINViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var pinTextField1: UITextField!
  @IBOutlet weak var pinTextField2: UITextField!
  @IBOutlet weak var pinTextField3: UITextField!
  @IBOutlet weak var pinTextField4: UITextField!
  
  var textFields = [UITextField]()
  var pin = ""
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextFieldPIN()
    setupClearNavigation()
  }
  
  // MARK: - Action Members
  @IBAction func performOperationTapped(_ sender: UIButton) {
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count < 4 {
      guard let title = sender.currentTitle, !title.isEmpty else { return }
      pin.append(title)
      textFields[pin.count - 1].text = title
      print(pin)
    }
    
    if sender.currentImage == #imageLiteral(resourceName: "clear-symbol") {
      if pin.count == 0 {
        return
      }
      
      _ = pin.removeLast()
      textFields[pin.count].text = ""
    }
    
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count == 4 {
      print("Success")
    }
  }
}

// MARK: - Private Members
private extension CreateTransactionPINViewController {
  func setupTextFieldPIN() {
    textFields = [pinTextField1, pinTextField2, pinTextField3, pinTextField4]
    
    textFields.forEach { (textField) in
      textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
      textField.isSecureTextEntry = true
      textField.font = UIFont.boldSystemFont(ofSize: 16)
    }
  }
}
