//
//  UserDefaults+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 9/5/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
  enum Bytes: String {
    case decryptedSk
    case decryptedLoginSk
    case decryptedBalanceInquirySk
    case byteHandle
  }
  
  case handle
  case sk
  case pin
  case language
  case username
  case backgroundTime
  case skipPIN
  case alreadyDisplayedAlertPIN
  case alreadyCreatedTransactionPIN
  case encryptedtPin
  case fromRegister
}

extension UserDefaults {
  
  // MARK: - UserDefaults for Bytes
  static func set(bytes: [UInt8]?, forKey key: UserDefaultsKey.Bytes) {
    UserDefaults.standard.set(bytes, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func bytes(forKey key: UserDefaultsKey.Bytes) -> [UInt8]? {
    return UserDefaults.standard.object(forKey: key.rawValue) as? [UInt8]
  }
  
  static func removeBytes(forKey key: UserDefaultsKey.Bytes) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  // MARK: - UserDefaults for Bool
  static func set(value: Bool, forKey key: UserDefaultsKey) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func boolValue(forKey key: UserDefaultsKey) -> Bool {
    return UserDefaults.standard.bool(forKey: key.rawValue)
  }
  
  // MARK: - UserDefaults for String
  static func set(value: String, forKey key: UserDefaultsKey) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func value(forKey key: UserDefaultsKey) -> String? {
    return UserDefaults.standard.string(forKey: key.rawValue)
  }
  
  // MARK: - Remove / Reset UserDefaults Objects
  static func removeValue(forKey key: UserDefaultsKey) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }
  
  static func resetAllValues() {
    UserDefaults.removeValue(forKey: .sk)
    UserDefaults.removeValue(forKey: .handle)
    UserDefaults.removeValue(forKey: .pin)
    UserDefaults.removeValue(forKey: .username)
    UserDefaults.removeValue(forKey: .backgroundTime)
    UserDefaults.removeValue(forKey: .encryptedtPin)
    UserDefaults.removeValue(forKey: .skipPIN)
    UserDefaults.removeValue(forKey: .language)
    UserDefaults.removeValue(forKey: .fromRegister)
    UserDefaults.removeValue(forKey: .alreadyDisplayedAlertPIN)
    UserDefaults.removeValue(forKey: .alreadyCreatedTransactionPIN)
    UserDefaults.removeBytes(forKey: .decryptedSk)
    UserDefaults.removeBytes(forKey: .decryptedLoginSk)
    UserDefaults.removeBytes(forKey: .byteHandle)
    UserDefaults.removeBytes(forKey: .decryptedBalanceInquirySk)
  }
}
