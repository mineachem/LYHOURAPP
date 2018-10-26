//
//  UpdateCredentialViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct UpdateCredentialViewModel {
  
  let deviceId: String
  let handle: String
  let lang: String
  let pin: String
  let timeStamp: String
  let sk: String
  let authByOTP: Bool
  let isFromLoggingIn: Bool
  let tpin: String
  let authModel: AuthViewModel?
  
  private let credentialRequestParam = UserAuthAPIParameters.Request.UpdateCredential.self
  
  var parameters: Parameters {
    if !pin.isEmpty {
      guard let encryptedPin = self.encryptedPin else { return [:] }
      let signatureText = "\(authByOTP)\(deviceId)\(handle)\(lang)\(encryptedPin)\(timeStamp)"
      let signature: String
      let signatureKey: String
      
      if let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedSk), UserDefaults.value(forKey: .pin) != nil {
        signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedLoginSk)
        signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
      } else {
        signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedSk)
        signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
      }
      
      return [
        credentialRequestParam.deviceId.rawValue  : deviceId,
        credentialRequestParam.handle.rawValue    : handle,
        credentialRequestParam.lang.rawValue      : lang,
        credentialRequestParam.pin.rawValue       : encryptedPin,
        credentialRequestParam.authByOTP.rawValue : authByOTP,
        credentialRequestParam.timeStamp.rawValue : timeStamp,
        credentialRequestParam.signature.rawValue : signature
      ]
    }
    
    if !tpin.isEmpty {
      guard let encryptedTPin = self.encryptedTPin, let decryptedSk = UserDefaults.bytes(forKey: .decryptedSk) else { return [:] }
      let signatureText = "\(authByOTP)\(deviceId)\(handle)\(lang)\(timeStamp)\(encryptedTPin)"
      let signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedSk)
      let signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
      return [
        credentialRequestParam.deviceId.rawValue  : deviceId,
        credentialRequestParam.handle.rawValue    : handle,
        credentialRequestParam.lang.rawValue      : lang,
        credentialRequestParam.tpin.rawValue      : encryptedTPin,
        credentialRequestParam.authByOTP.rawValue : authByOTP,
        credentialRequestParam.timeStamp.rawValue : timeStamp,
        credentialRequestParam.signature.rawValue : signature
      ]
    }
    
    return [:]
  }
  
  init(isFromLoggingIn: Bool, authModel: AuthViewModel? = nil, authByOTP: Bool, deviceId: String, handle: String, lang: String, pin: String? = nil, tpin: String? = nil, timeStamp: String, sk: String) {
    self.isFromLoggingIn = isFromLoggingIn
    self.authModel = authModel
    self.authByOTP = authByOTP
    self.deviceId = deviceId
    self.handle = handle
    self.lang = lang
    self.pin = pin ?? ""
    self.tpin = tpin ?? ""
    self.timeStamp = timeStamp.utcToDateString()
    self.sk = sk
  }
}

private extension UpdateCredentialViewModel {
  private var decryptedSk: [UInt8] {
    guard let bytesHandle = handle.base64StringToByteArray() else { return [] }
    guard let bytesSk = sk.base64StringToByteArray() else { return [] }
    guard let authModel = self.authModel else { return [] }
    
    let hexDecryptedSk: [UInt8]
    if isFromLoggingIn {
      hexDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: authModel.decryptedLoginSK)
    } else {
      hexDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: authModel.decryptedSK)
    }
    
    if let sk = JARVISViewModelUtils.decrypt(values: bytesSk, withKey: hexDecryptedSk, withIv: bytesHandle) {
      UserDefaults.set(bytes: sk, forKey: .decryptedSk)
      UserDefaults.set(bytes: bytesHandle, forKey: .byteHandle)
      return sk
    }
    
    return []
  }
  
  private var encryptedPin: String? {
    guard let bytesHandle = handle.base64StringToByteArray() else { return nil }
    
    let pin = [UInt8](self.pin.utf8)
    let skKey: [UInt8]
    
    if let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedSk), UserDefaults.value(forKey: .pin) != nil {
      skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedLoginSk)
    } else {
      skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedSk)
    }
    
    if let enPin = JARVISViewModelUtils.encrypt(values: pin, withKey: skKey, withIv: bytesHandle) {
      return enPin
    }
    return nil
  }
  
  private var encryptedTPin: String? {
    guard let decryptedSk = UserDefaults.bytes(forKey: .decryptedSk) else { return nil }
    guard let bytesHandle = handle.base64StringToByteArray() else { return nil }
    let tpin = [UInt8](self.tpin.utf8)
    let skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedSk)
    if let enTPin = JARVISViewModelUtils.encrypt(values: tpin, withKey: skKey, withIv: bytesHandle) {
      UserDefaults.set(value: enTPin, forKey: .encryptedtPin)
      return enTPin
    }
    return nil
  }
}
