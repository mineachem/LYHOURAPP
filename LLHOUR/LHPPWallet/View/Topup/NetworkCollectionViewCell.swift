//
//  NetworkCollectionViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/1/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class NetworkCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override var isSelected: Bool {
    willSet {
      if newValue && selectedBackgroundView == nil {
        selectedBackgroundView = CircleView()
      }
    }
  }
}
