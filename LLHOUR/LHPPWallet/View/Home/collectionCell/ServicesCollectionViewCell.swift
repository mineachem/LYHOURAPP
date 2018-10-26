//
//  ServicesCollectionViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var logoServiceImageView: UIImageView!
  @IBOutlet weak var titleSerivceLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        titleSerivceLabel.font = UIFont.systemFont(ofSize: 14)
      } else if UIDevice.isPhone678 {
        titleSerivceLabel.font = UIFont.systemFont(ofSize: 13)
      } else {
        titleSerivceLabel.font = UIFont.systemFont(ofSize: 12)
      }
    }
  }
  
  func configureCell(image: UIImage?, title: String) {
    logoServiceImageView.image = image
    titleSerivceLabel.text = title
  }
}
