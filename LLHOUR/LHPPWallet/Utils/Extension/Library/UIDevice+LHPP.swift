//
//  UIDevice+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import DeviceKit

extension UIDevice {
  static var deviceId: String {
    guard let uuidString = UIDevice.current.identifierForVendor?.uuidString else { return ""}
    return uuidString.replacingOccurrences(of: "-", with: "")
  }
  
  static var isPhone5SE: Bool {
    return  currentDevice == .iPhoneSE || currentDevice == .simulator(.iPhoneSE) ||
            currentDevice == .iPhone5s || currentDevice == .simulator(.iPhone5s) ||
            currentDevice == .iPhone5  || currentDevice == .simulator(.iPhone5)
  }
  
  static var isPhone678: Bool {
    return  currentDevice == .iPhone6 || currentDevice == .simulator(.iPhone6) ||
            currentDevice == .iPhone7 || currentDevice == .simulator(.iPhone7) ||
            currentDevice == .iPhone8 || currentDevice == .simulator(.iPhone8)
  }
  
  static var isPhone678Plus: Bool {
    return  currentDevice == .iPhone6Plus || currentDevice == .simulator(.iPhone6Plus) ||
            currentDevice == .iPhone7Plus || currentDevice == .simulator(.iPhone7Plus) ||
            currentDevice == .iPhone8Plus || currentDevice == .simulator(.iPhone8Plus)
  }
  
  static var isPhoneXs: Bool {
    return  currentDevice == .iPhoneX  || currentDevice == .simulator(.iPhoneX) ||
            currentDevice == .iPhoneXs || currentDevice == .simulator(.iPhoneXs)
  }
  
  static var isPhoneXR: Bool {
    return  currentDevice == .iPhoneXr || currentDevice == .simulator(.iPhoneXr)
  }
  
  static var isPhoneXsMax: Bool {
    return  currentDevice == .iPhoneXsMax || currentDevice == .simulator(.iPhoneXsMax)
  }
  
  static var isBiggerPhone: Bool {
    return UIDevice.isPhoneXs || UIDevice.isPhoneXR
  }
  
  static var isBiggestPhone: Bool {
    return UIDevice.isPhone678Plus || UIDevice.isPhoneXsMax
  }
}

private extension UIDevice {
  static var currentDevice: Device {
    return Device()
  }
}
