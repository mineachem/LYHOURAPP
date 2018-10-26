//
//  ProfileContentCell.swift
//  LHPP Wallet
//
//  Created by User on 8/2/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class ProfileContentCell: UITableViewCell {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.fontSize = UIDevice.isPhone5SE ? 15 : 17
    }
  }
  
}
