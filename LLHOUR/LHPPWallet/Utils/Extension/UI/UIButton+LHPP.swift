//
//  UIButton+LHPP.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/25/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

extension UIButton {
  func configureStyle() {
    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    } else {
      titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }
  }
}
