//
//  OfferDetailViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/13/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class OfferDetailViewController: UIViewController {
  
  @IBOutlet weak var contentOfferDetail: UIView!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UIView!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var discountTitleLabel: UILabel!
  @IBOutlet weak var descriptLabel: UILabel!
  @IBOutlet weak var termTitleLabel: UILabel!
  @IBOutlet weak var descriptOneLabel: UILabel!
  @IBOutlet weak var descriptTwoLabel: UILabel!
  @IBOutlet weak var descriptThreeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupClearNavigation()
  }
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  @IBAction func gotoMapScreenTapped(_ sender: RoundButton) {
    
  }
}
