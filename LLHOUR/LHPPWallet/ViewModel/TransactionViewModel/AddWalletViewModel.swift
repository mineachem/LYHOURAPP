//
//  AddWalletViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/2/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

private let addWalletParam = TransactionAPIParameters.Response.AddWallet.self

struct AddWalletViewModel {
  let currency: String
  let deviceId: String
  let handle: String
  let lang: String
  let timeStamp: String
  
  var parameters: Parameters {
    let signatureText = "\(currency)\(deviceId)\(handle)\(lang)\(timeStamp)"
    let signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedSk)
    let signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
    return [addWalletParam.currency.rawValue  : currency,
            addWalletParam.deviceId.rawValue  : deviceId,
            addWalletParam.handle.rawValue    : handle,
            addWalletParam.lang.rawValue      : lang,
            addWalletParam.timeStamp.rawValue : timeStamp,
            addWalletParam.signature.rawValue : signature
    ]
  }
  
  private var decryptedSk: [UInt8] {
    if let sk = UserDefaults.bytes(forKey: .decryptedBalanceInquirySk) {
      return sk
    }
    return []
  }
  
  init(currency: String, deviceId: String, handle: String, lang: String, timeStamp: String) {
    self.currency = currency
    self.deviceId = deviceId
    self.handle = handle
    self.lang = lang
    self.timeStamp = timeStamp.utcToDateString()
  }
}
