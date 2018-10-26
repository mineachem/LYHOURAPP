//
//  UILabel+LHPP.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/25/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

extension UILabel {
  func detailStyle() {
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      font = UIFont.preferredFont(forTextStyle: .body)
    } else {
      font = UIFont.preferredFont(forTextStyle: .callout)
    }
  }
}
