//
//  UIApplication.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/8/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

extension UIApplication {
  var rootViewController: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
  }
  
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}
