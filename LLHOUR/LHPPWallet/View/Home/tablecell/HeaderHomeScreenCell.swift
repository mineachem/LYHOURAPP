//
//  HeaderHomeScreenCell.swift
//  LHPP Wallet
//
//  Created by User on 8/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class HeaderHomeScreenCell: UITableViewCell {
  
  @IBOutlet weak var leftTitleLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
      } else if UIDevice.isPhone678 {
        leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
      } else {
        leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
      }
    }
  }
  
  @IBOutlet weak var showAllButton: UIButton! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
      } else if UIDevice.isPhone678 {
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
      } else {
        showAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
      }
    }
  }
}
