//
//  BalanceInquiryViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/27/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct BalanceInquiryViewModel {
  let acNo: String
  let deviceId: String
  let handle: String
  let lang: String
  let timeStamp: String
  var authModel: AuthViewModel?
  var authResponse: AuthResponse?
  
  private let balanceInquiryParam = TransactionAPIParameters.Request.BalanceInquiry.self
  
  var parameters: Parameters {
    let signatureText = "\(acNo)\(deviceId)\(handle)\(lang)\(timeStamp)"
    let signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedSk)
    let signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
    return [balanceInquiryParam.acNo.rawValue     : acNo,
            balanceInquiryParam.deviceId.rawValue : deviceId,
            balanceInquiryParam.handle.rawValue   : handle,
            balanceInquiryParam.lang.rawValue     : lang,
            balanceInquiryParam.timeStamp.rawValue: timeStamp,
            balanceInquiryParam.signature.rawValue: signature
    ]
  }
  
  init(authModel: AuthViewModel? = nil, authResponse: AuthResponse? = nil, acNo: String, deviceId: String, handle: String, lang: String, timeStamp: String) {
    self.authModel = authModel
    self.authResponse = authResponse
    self.acNo = acNo
    self.deviceId = deviceId
    self.handle = handle
    self.lang = lang
    self.timeStamp = timeStamp.utcToDateString()
  }
}

private extension BalanceInquiryViewModel {
  var decryptedSk: [UInt8] {
    guard let bytesHandle = handle.base64StringToByteArray(), let authModel = self.authModel, let authResponse = self.authResponse else { return [] }
    
    let authResponseSk = authResponse.sk?.base64StringToByteArray() ?? []
    let authDecryptedSk: [UInt8]
    
    if let decryptedBalanceInquirySk = UserDefaults.bytes(forKey: .decryptedBalanceInquirySk) {
      authDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedBalanceInquirySk)
    } else if UserDefaults.boolValue(forKey: .fromRegister) {
      authDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: authModel.decryptedSK)
    } else {
      authDecryptedSk = JARVISViewModelUtils.generateEnDecryptionKeys(with: authModel.decryptedLoginSK)
    }
    
    if let sk = JARVISViewModelUtils.decrypt(values: authResponseSk, withKey: authDecryptedSk, withIv: bytesHandle) {
      UserDefaults.set(bytes: sk, forKey: .decryptedBalanceInquirySk)
      return sk
    }
    return []
  }
}
