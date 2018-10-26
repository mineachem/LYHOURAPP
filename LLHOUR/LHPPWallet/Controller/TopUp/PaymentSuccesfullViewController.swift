//
//  PaymentSuccesfullViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/27/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard

class PaymentSuccesfullViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  @IBAction func addToFavorite(_ sender: UIButton) {
    
  }
  
  @IBAction func doneTapped(_ sender: RoundButton) {
    navigationController?.popToRootViewController(animated: true)
  }
}
