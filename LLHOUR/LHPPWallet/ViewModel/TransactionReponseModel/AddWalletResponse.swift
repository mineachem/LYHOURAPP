//
//  AddWalletResponse.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/2/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwiftyJSON

private let addWalletParam = TransactionAPIParameters.Response.AddWallet.self

struct AddWalletResponse {
  var handle: String?
  var info: JSONDictionary?
  var acNo: JSONDictionary?
  var proxy: String?
  var value: String?
  var active: Bool = false
  var balance: JSONDictionary?
  var currency: String?
  var isDefault: Bool = false
  var ofWallet: Bool = false
  var lang: String?
  var timeStamp: String?

  //swiftlint:disable force_cast
  init(json: JSON) {
    handle = json[addWalletParam.handle.rawValue].string
    info = json[addWalletParam.info.rawValue].dictionaryObject
    if let infoDict = info {
      if let acNoDict = infoDict[addWalletParam.acNo.rawValue] as? JSONDictionary {
        acNo = acNoDict
        proxy = acNoDict[addWalletParam.proxy.rawValue] as? String
        value = acNoDict[addWalletParam.value.rawValue] as? String
      }
      active = infoDict[addWalletParam.active.rawValue] as! Bool
      balance = infoDict[addWalletParam.balance.rawValue] as? JSONDictionary
      currency = infoDict[addWalletParam.currency.rawValue] as? String
      isDefault = infoDict[addWalletParam.isDefault.rawValue] as! Bool
      ofWallet = infoDict[addWalletParam.ofWallet.rawValue] as! Bool
    }
    lang = json[addWalletParam.lang.rawValue].string
    timeStamp = json[addWalletParam.timeStamp.rawValue].string
  }
}
