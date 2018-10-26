//
//  AuthResponse.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AuthResponse {
  var currency: [JSON]?
  var sk: String?
  var user: JSONDictionary?
  var uid: String?
  var walletType: JSONDictionary?
  var walletFamily: JSONDictionary?
  var accounts: [JSON]?
  var timeStamp: String?
  var authBy: JSONDictionary?
  var cards: [Any]?
  var others: JSONDictionary?
  var referral: String?
  var handle: String?
  
  private let authResponseParam = UserAuthAPIParameters.Response.Auth.self
  
  init(json: JSON) {
    currency      = json[authResponseParam.currency.rawValue].array
    sk            = json[authResponseParam.sk.rawValue].string
    user          = json[authResponseParam.user.rawValue].dictionaryObject
    uid           = json[authResponseParam.uid.rawValue].string
    walletType    = json[authResponseParam.walletType.rawValue].dictionary
    walletFamily  = json[authResponseParam.walletFamily.rawValue].dictionary
    accounts      = json[authResponseParam.accounts.rawValue].array
    timeStamp     = json[authResponseParam.timeStamp.rawValue].string
    authBy        = json[authResponseParam.authBy.rawValue].dictionary
    cards         = json[authResponseParam.cards.rawValue].arrayObject
    others        = json[authResponseParam.others.rawValue].dictionary
    referral      = json[authResponseParam.referral.rawValue].string
    handle        = json[authResponseParam.handle.rawValue].string
  }
}
