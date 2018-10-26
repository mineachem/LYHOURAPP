//
//  Slide.swift
//  LHPP Wallet
//
//  Created by User on 8/17/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class Slide: UIView {
  
  @IBOutlet weak var currencyLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        currencyLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      } else {
        currencyLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
      }
    }
  }
  
  @IBOutlet weak var pricesLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        pricesLabel.font = UIFont.preferredFont(forTextStyle: .title3)
      } else {
        pricesLabel.font = UIFont.preferredFont(forTextStyle: .body)
      }
    }
  }
  
  @IBOutlet weak var cardNumberLabel: UILabel! {
    didSet {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        cardNumberLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      } else {
        cardNumberLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
      }
    }
  }
}
