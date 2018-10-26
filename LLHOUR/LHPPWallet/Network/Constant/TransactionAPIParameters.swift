//
//  TransactionAPIParameters.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

enum TransactionAPIParameters {
  enum Request {
    enum BalanceInquiry: String {
      case deviceId         = "_deviceId"
      case handle           = "_handle"
      case acNo             = "_acNo"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
    }
  }
  
  enum Response {
    enum AddWallet: String {
      case currency         = "_currency"
      case deviceId         = "_deviceId"
      case handle           = "_handle"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
      case info             = "_info"
      case acNo             = "_acNo"
      case proxy            = "_proxy"
      case value            = "_value"
      case active           = "_active"
      case balance          = "_balance"
      case isDefault        = "_default"
      case ofWallet         = "_ofWallet"
    }
    
    enum BalanceInquiry: String {
      case deviceId         = "_deviceId"
      case handle           = "_handle"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
      case acNo             = "_acNo"
      case proxy            = "_proxy"
      case value            = "_value"
      case active           = "_active"
      case balance          = "_balance"
      case balances         = "_balances"
      case available        = "_available"
      case blocked          = "_blocked"
      case ledger           = "_ledger"
      case currency         = "_currency"
      case isDefault        = "_default"
      case ofWallet         = "_ofWallet"
    }
  }
}
