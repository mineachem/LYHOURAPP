//
//  BalanceInquiryReponse.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/27/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwiftyJSON

private let balanceResponse  = TransactionAPIParameters.Response.BalanceInquiry.self

struct BalanceInquiryReponse {
  
  var acNo      : Parameters
  var balance   : Parameters
  var balances  : [JSON]
  var currency  : String?
  var active    : Bool = false
  var isDefault : Bool = false
  var ofWallet  : Bool = false
  var value     : String?
  var proxy     : String?
  var balanceAvailable: Double?
  var balanceLedger: Double?
  var balanceBlocked: Double?
  var handle    : String?
  var lang      : String?
  var timeStamp : String?
  
  init(json: JSON) {
    if let balances = json[balanceResponse.balances.rawValue].array {
      self.balances = balances
      acNo      = balances.map({$0[balanceResponse.acNo.rawValue]}).first!.dictionaryValue
      balance   = balances.map({$0[balanceResponse.balance.rawValue]}).first!.dictionaryValue
      active    = balances.map({$0[balanceResponse.active.rawValue]}).first!.boolValue
      currency  = balances.map({$0[balanceResponse.currency.rawValue]}).first!.stringValue
      isDefault = balances.map({$0[balanceResponse.isDefault.rawValue]}).first!.boolValue
      ofWallet  = balances.map({$0[balanceResponse.isDefault.rawValue]}).first!.boolValue
      value     = (acNo[balanceResponse.value.rawValue] as? JSON)?.stringValue
      proxy     = (acNo[balanceResponse.proxy.rawValue] as? JSON)?.stringValue
      balanceAvailable = (balance[balanceResponse.available.rawValue] as? JSON)?.doubleValue
      balanceLedger    = (balance[balanceResponse.ledger.rawValue] as? JSON)?.doubleValue
      balanceBlocked   = (balance[balanceResponse.blocked.rawValue] as? JSON)?.doubleValue
    } else {
      acNo      = [:]
      balance   = [:]
      balances  = []
      active    = false
      currency  = ""
      isDefault = false
      ofWallet  = false
      value     = ""
      proxy     = ""
      balanceAvailable = nil
      balanceLedger = nil
      balanceBlocked = nil
    }
    handle    = json[balanceResponse.handle.rawValue].stringValue
    lang      = json[balanceResponse.lang.rawValue].stringValue
    timeStamp = json[balanceResponse.timeStamp.rawValue].stringValue
  }
}
