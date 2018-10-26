//
//  SlidebarHeaderCellTableViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class SlidebarHeaderCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: RoundedWhiteBgImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phonenumLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
    } else {
      nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
    }
    phonenumLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    emailLabel.font = UIFont.preferredFont(forTextStyle: .callout)
  }
}
