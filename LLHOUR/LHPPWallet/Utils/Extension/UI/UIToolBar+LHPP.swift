//
//  UIToolBar+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 9/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

extension UIToolbar {
  func initToolBar(with barButtonItem: UIBarButtonItem) {
    barStyle = .default
    sizeToFit()
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    setItems([flexSpace, barButtonItem], animated: true)
  }
}
