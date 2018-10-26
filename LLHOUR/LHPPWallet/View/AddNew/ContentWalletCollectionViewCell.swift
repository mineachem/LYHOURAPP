//
//  ContentWalletCollectionViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class ContentWalletCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
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
