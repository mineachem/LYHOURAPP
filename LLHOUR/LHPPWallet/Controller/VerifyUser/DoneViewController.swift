//
//  DoneViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/27/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  @IBAction func doneTapped(_ sender: RoundButton) {
  }
}
