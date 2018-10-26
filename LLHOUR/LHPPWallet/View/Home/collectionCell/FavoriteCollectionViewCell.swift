//
//  FavoriteCollectionViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var addFavImageView: UIImageView!
  @IBOutlet weak var titleFavLabel: UILabel!
  
  func configureCell(image: UIImage?, title: String) {
    addFavImageView.image = image
    titleFavLabel.text = title
  }
}
