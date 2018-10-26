//
//  SlidebarContentCell.swift
//  LHPP Wallet
//
//  Created by User on 8/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class SlidebarContentCell: UITableViewCell {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var contentTitleLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        contentTitleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      } else {
        contentTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
      }
    }
  }
}
