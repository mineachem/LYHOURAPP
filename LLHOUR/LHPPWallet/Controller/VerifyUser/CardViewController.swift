//
//  CardViewController.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/9/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit
import Material
import Motion

class CardViewController: UIViewController {
  
  @IBOutlet weak var displayLabel: UILabel!
  @IBOutlet weak var inputTextField: TextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTextField()
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  func setupTextField() {
    
    inputTextField.placeholderActiveColor = .red
  }
  
}

extension CardViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
}
