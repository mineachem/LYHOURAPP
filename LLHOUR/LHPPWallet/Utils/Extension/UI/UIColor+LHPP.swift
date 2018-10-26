//
//  Extensions.swift
//  LHPP Wallet
//
//  Created by User on 7/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

extension UIColor {
  static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
  }
  
  static var darkBlue: UIColor {
    return rgbColor(red: 48.0, green: 91.0, blue: 148.0)
  }
  
  static var redRoundButton: UIColor {
    return rgbColor(red: 209.0, green: 56.0, blue: 78.0)
  }
  
  static func colorFromHex(_ hex: String) -> UIColor {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if hexString.hasPrefix("#") {
      hexString.remove(at: hexString.startIndex)
    }
    
    if hexString.count != 6 {
      return UIColor.magenta
    }
    
    var rgb: UInt32 = 0
    Scanner.init(string: hexString).scanHexInt32(&rgb)
    
    return UIColor.init(red:    CGFloat((rgb & 0xFF0000) >> 16) / 255,
                        green:  CGFloat((rgb & 0x00FF00) >> 8) / 255,
                        blue:   CGFloat(rgb & 0x0000FF) / 255,
                        alpha:  1.0)
  }
}
