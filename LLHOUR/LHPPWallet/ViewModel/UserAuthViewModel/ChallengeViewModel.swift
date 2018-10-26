//
//  ChallengeViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct ChallengeViewModel {
  // MARK: - Public
  var decryptedIkHex64String: String {
    return decryptedIk.toHexString().uppercased().toHex64String
  }
  
  // Paramaters
  var parameters: Parameters {
    guard let decryptedCrp = decryptedCrpBase64String else { return [:] }
    let signatureText = "\(decryptedCrp)\(deviceId)\(handle)\(lang)\(timeStamp)"
    let signature = JARVISViewModelUtils.generateSignature(with: decryptedIk.toHexString().uppercased(), signatureText: signatureText)
    return [  challengeRequestParam.crv.rawValue        : decryptedCrp,
              challengeRequestParam.deviceId.rawValue   : deviceId,
              challengeRequestParam.handle.rawValue     : handle,
              challengeRequestParam.lang.rawValue       : lang,
              challengeRequestParam.timeStamp.rawValue  : timeStamp,
              challengeRequestParam.signature.rawValue  : signature
    ]
  }
  
  let deviceId: String
  let countryCode: Int
  let otp: Int
  let ik: String
  let crp: String
  let handle: String
  let lang: String
  let mobile: Int
  let timeStamp: String
  
  private let challengeRequestParam = UserAuthAPIParameters.Request.Challenge.self
  
  // MARK: - Initialize
  init(deviceId: String, otp: Int, countryCode: Int, mobile: Int, crp: String, ik: String, handle: String, lang: String, timeStamp: String) {
    self.deviceId = deviceId
    self.countryCode = countryCode
    self.otp = otp
    self.crp = crp
    self.ik = ik
    self.handle = handle
    self.lang = lang
    self.mobile = mobile
    self.timeStamp = timeStamp.utcToDateString()
  }
}

// MARK: - JARVISViewModel.Challenge Private Members
private extension ChallengeViewModel {
  var decryptedIk: [UInt8] {
    guard let bytesKey = key.hexStringToBytes(), let bytesHandle = handle.base64StringToByteArray(), let bytesIk = ik.base64StringToByteArray() else { return [] }
    if let ikKey = JARVISViewModelUtils.decrypt(values: bytesIk, withKey: bytesKey, withIv: bytesHandle) {
      return ikKey
    }
    return []
  }
  
  var decryptedCrpBase64String: String? {
    guard let bytesKey = key.hexStringToBytes(), let bytesHandle = handle.base64StringToByteArray(), let bytesCrp = crp.base64StringToByteArray() else { return "" }
    if let decryptedCrp = JARVISViewModelUtils.decrypt(values: bytesCrp, withKey: bytesKey, withIv: bytesHandle)?.toBase64() {
      return decryptedCrp
    }
    return ""
  }
  
  var key: String {
    // Convert Mobile Number
    let convertedMobileNumber = String(describing: mobile).dropLast()
    // Combine otp, countryCode, mobile and add `F` to make it 64 Digits to make KEY
    let combineText = "\(otp)\(countryCode)\(convertedMobileNumber)"
    return JARVISViewModelUtils.convertToHex64DigitKey(with: combineText)
  }
}
