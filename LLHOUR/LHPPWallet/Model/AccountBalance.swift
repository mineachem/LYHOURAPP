//
//  Account.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/1/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwiftyJSON

private let authResponse  = UserAuthAPIParameters.Response.Auth.self

struct AccountBalance {
  var acNo      : Parameters?
  var balance   : Parameters?
  var currency  : String?
  var active    : Bool = false
  var isDefault : Bool = false
  var ofWallet  : Bool = false
  var value     : String?
  var proxy     : String?
  var balanceAvailable: Double?
  var balanceLedger: Double?
  var balanceBlocked: Double?
  
  //swiftlint:disable force_cast
  init(json: JSON) {
    if let accountBalance = json.dictionaryObject {
      acNo = accountBalance[authResponse.acNo.rawValue] as? JSONDictionary
      balance = accountBalance[authResponse.balance.rawValue] as? JSONDictionary
      currency = accountBalance[authResponse.currency.rawValue] as? String
      active = accountBalance[authResponse.active.rawValue] as! Bool
      isDefault = accountBalance[authResponse.isDefault.rawValue] as! Bool
      ofWallet = accountBalance[authResponse.ofWallet.rawValue] as! Bool
      if let acNoDict = acNo {
        value = acNoDict[authResponse.value.rawValue] as? String
        proxy = acNoDict[authResponse.proxy.rawValue] as? String
      }
      if let balanceDict = balance {
        balanceAvailable = balanceDict[authResponse.available.rawValue] as? Double
        balanceLedger = balanceDict[authResponse.ledger.rawValue] as? Double
        balanceBlocked = balanceDict[authResponse.blocked.rawValue] as? Double
      }
    }
  }
}

struct AccountNo {
  var proxy: String?
  var value: String?
}

struct Balance {
  var available: Double?
  var ledger: Double?
  var blocked: Double?
}
