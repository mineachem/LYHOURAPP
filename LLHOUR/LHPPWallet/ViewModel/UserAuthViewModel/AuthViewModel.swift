//
//  AuthViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

private let authRequestParam = UserAuthAPIParameters.Request.Auth.self

struct AuthViewModel {
  // MARK: - Public
  let deviceId: String
  let handle: String
  let lang: String
  let pin: String
  let timeStamp: String
  let userName: String
  let userPass: String
  let onlyAuth: Bool
  let otp: Int
  let registerResponse: RegisterResponse?
  let challengeModel: ChallengeViewModel?
  let challengeResponse: ChallengeResponse?
  let challengeSk: String
  
  private let sk: String
  private let registerModel: RegisterViewModel?
  
  var decryptedSK: [UInt8] {
    guard let bytesHandle = handle.base64StringToByteArray() else { return [] }
    guard let bytesSk = sk.base64StringToByteArray() else { return [] }
    guard let model = registerModel else { return [] }
    let decryptedFkKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: model.decryptedFk)
    if let sk = JARVISViewModelUtils.decrypt(values: bytesSk, withKey: decryptedFkKey, withIv: bytesHandle) {
      UserDefaults.set(bytes: sk, forKey: .decryptedSk)
      UserDefaults.set(bytes: bytesHandle, forKey: .byteHandle)
      return sk
    }
    
    return []
  }
  
  var decryptedLoginSK: [UInt8] {
    guard let bytesLoginSk = challengeSk.base64StringToByteArray() else { return [] }
    guard let challengeHandle = challengeResponse?.handle, let bytesLoginHandle = challengeHandle.base64StringToByteArray() else { return []}
    let skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedIk)
    if let decryptedSk = JARVISViewModelUtils.decrypt(values: bytesLoginSk, withKey: skKey, withIv: bytesLoginHandle) {
      return decryptedSk
    }
    return []
  }
  
  func saveDecryptedData(withResponse authResponse: AuthResponse, withKey key: UserDefaultsKey.Bytes) {
    guard let sk = authResponse.sk, let handle = authResponse.handle else { return }
    let bytesHandle = handle.base64StringToByteArray() ?? []
    let bytesSk = sk.base64StringToByteArray() ?? []
    
    guard let previousDecryptedSk = UserDefaults.bytes(forKey: key) else { return }
    let preDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: previousDecryptedSk)
    if let decryptedSk = JARVISViewModelUtils.decrypt(values: bytesSk, withKey: preDecryptedSk, withIv: bytesHandle) {
      UserDefaults.set(bytes: decryptedSk, forKey: key)
      UserDefaults.set(bytes: bytesHandle, forKey: .byteHandle)
      UserDefaults.set(value: handle, forKey: .handle)
    }
  }
  
  var parameters: Parameters {
    let signature: String
    let encryptedPassword: String
    let signatureKey: String
    
    // ------------------------ EXISTIN LOGIN WITH PIN FLOW ------------------------ //
    if let encryptedPIN = encryptedPin, !UserDefaults.boolValue(forKey: .skipPIN) {
      guard let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedSk), let pinHandle = UserDefaults.value(forKey: .handle), let username = UserDefaults.value(forKey: .username) else { return [:] }
      let signatureText = "\(deviceId)\(pinHandle)\(lang)\(onlyAuth)\(encryptedPIN)\(timeStamp)\(username)\(userPass)"
      signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedLoginSk)
      signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
      return [  authRequestParam.handle.rawValue      : handle,
                authRequestParam.deviceId.rawValue    : deviceId,
                authRequestParam.pin.rawValue         : encryptedPIN,
                authRequestParam.lang.rawValue        : lang,
                authRequestParam.timeStamp.rawValue   : timeStamp,
                authRequestParam.onlyAuth.rawValue    : onlyAuth,
                authRequestParam.userName.rawValue    : username,
                authRequestParam.userPass.rawValue    : "",
                authRequestParam.signature.rawValue   : signature
      ]
    }
    
    // ------------------------ REGISTER FLOW ------------------------ //
    if self.challengeResponse == nil {
      let signatureText: String
      encryptedPassword = self.encryptedPassword ?? ""
      if let handle = UserDefaults.value(forKey: .handle), UserDefaults.boolValue(forKey: .skipPIN) {
        signatureText = "\(deviceId)\(handle)\(lang)\(onlyAuth)\(timeStamp)\(userName)\(encryptedPassword)"
        print("Login After User skip for PIN")
        print("Handle: ", handle)
        print("Signature:", signatureText)
        guard let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedLoginSk) else { return [:] }
        signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedLoginSk)
        signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
        print("Signature Key: ", signatureKey)
        print("Signature: ", signature)
      } else {
        signatureText = "\(deviceId)\(handle)\(lang)\(onlyAuth)\(timeStamp)\(userName)\(encryptedPassword)"
        print("Fresh Installation - Registration Flow")
        print("Handle: ", handle)
        print("Signature:", signatureText)
        signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedSK)
        signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
        print("Signature Key: ", decryptedSK.toHexString().uppercased())
        print("Signature: ", signature)
      }
    } else {
      // ------------------------ FRESH INSTALLATION LOG IN FLOW ------------------------ //
      encryptedPassword = self.encryptedLoginPassword ?? ""
      let signatureText = "\(deviceId)\(handle)\(lang)\(onlyAuth)\(timeStamp)\(userName)\(encryptedPassword)"
      signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedLoginSK)
      signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
    }
    
    return [  authRequestParam.handle.rawValue      : handle,
              authRequestParam.deviceId.rawValue    : deviceId,
              authRequestParam.userName.rawValue    : userName,
              authRequestParam.userPass.rawValue    : encryptedPassword,
              authRequestParam.lang.rawValue        : lang,
              authRequestParam.timeStamp.rawValue   : timeStamp,
              authRequestParam.onlyAuth.rawValue    : onlyAuth,
              authRequestParam.signature.rawValue   : signature
    ]
  }
  
  // MARK: - Init
  init(challengeModel: ChallengeViewModel? = nil,
       challengeResponse: ChallengeResponse? = nil,
       challengeSk: String? = nil,
       registerResponse: RegisterResponse? = nil,
       registerModel: RegisterViewModel? = nil,
       deviceId: String,
       handle: String,
       onlyAuth: Bool,
       lang: String,
       otp: Int? = nil,
       pin: String? = nil,
       userName: String? = nil,
       userPass: String? = nil,
       timeStamp: String) {
    self.registerResponse = registerResponse
    self.registerModel = registerModel
    self.challengeModel = challengeModel
    self.challengeResponse = challengeResponse
    self.challengeSk = challengeSk ?? ""
    self.otp = otp ?? 0
    self.sk = registerResponse?.sk ?? ""
    self.deviceId = deviceId
    self.handle = handle
    self.lang = lang
    self.pin = pin ?? ""
    self.onlyAuth = onlyAuth
    self.userName = userName ?? ""
    self.userPass = userPass ?? ""
    self.timeStamp = timeStamp.utcToDateString()
  }
}

private extension AuthViewModel {
  
  var decryptedSkHex64String: String {
    return decryptedSK.toHexString().uppercased().toHex64String
  }
  
  var decryptedLoginSkHex64String: String {
    return decryptedLoginSK.toHexString().toHex64String
  }
  
  // ------------------------ REGISTER FLOW ------------------------ //
  var encryptedPassword: String? {
    let userPassword = [UInt8](userPass.utf8)
    if UserDefaults.boolValue(forKey: .skipPIN), let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedLoginSk) {
      let skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedLoginSk)
      let bytesHandle = handle.base64StringToByteArray() ?? []
      if let encryptedPass = JARVISViewModelUtils.encrypt(values: userPassword, withKey: skKey, withIv: bytesHandle) {
        print("Login After User skip for PIN")
        print("Encrypted Password: ", encryptedPass)
        return encryptedPass
      }
    } else {
      guard let bytesHandle = handle.base64StringToByteArray() else { return nil }
      guard let hexDescryptedSK = decryptedSkHex64String.hexStringToBytes() else { return nil }
      if let encryptedPass = JARVISViewModelUtils.encrypt(values: userPassword, withKey: hexDescryptedSK, withIv: bytesHandle) {
        print("Fresh Installation - Registration Flow")
        print("Encrypted Password: ", encryptedPass)
        return encryptedPass
      }
    }
    return nil
  }
  
  // ------------------------ LOG IN FLOW ------------------------ //
  var encryptedLoginPassword: String? {
    guard let challengeHandle = challengeResponse?.handle, let bytesLoginHandle = challengeHandle.base64StringToByteArray() else { return nil }
    guard let hexDecryptedLoginSK = decryptedLoginSkHex64String.hexStringToBytes() else { return nil }
    let userPassword = [UInt8](userPass.utf8)
    if let encryptedPass = JARVISViewModelUtils.encrypt(values: userPassword, withKey: hexDecryptedLoginSK, withIv: bytesLoginHandle) {
      return encryptedPass
    }
    return nil
  }
    
  var decryptedIk: [UInt8] {
    guard let loginChallengeModel = self.challengeModel else { return [] }
    let convertedMobileNumber = String(describing: loginChallengeModel.mobile).dropLast()
    let combineText = "\(otp)\(loginChallengeModel.countryCode)\(convertedMobileNumber)"
    let key = JARVISViewModelUtils.convertToHex64DigitKey(with: combineText)
    let bytesKey = key.hexStringToBytes() ?? []
    
    let bytesIk = loginChallengeModel.ik.base64StringToByteArray() ?? []
    let handle = loginChallengeModel.handle.base64StringToByteArray() ?? []
    
    if let ikKey = JARVISViewModelUtils.decrypt(values: bytesIk, withKey: bytesKey, withIv: handle) {
      return ikKey
    }
    return []
  }
  
  // ------------------------ EXISTING LOGIN WITH PIN FLOW ------------------------ //
  var encryptedPin: String? {
    if UserDefaults.value(forKey: .pin) != nil {
      guard let decryptedLoginSk = UserDefaults.bytes(forKey: .decryptedSk), let bytesHandle = UserDefaults.bytes(forKey: .byteHandle) else { return nil }
      let skKey = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedLoginSk)
      let pin = [UInt8](self.pin.utf8)
      if let enPin = JARVISViewModelUtils.encrypt(values: pin, withKey: skKey, withIv: bytesHandle) {
        return enPin
      }
      return nil
    }
    return nil
  }
}
