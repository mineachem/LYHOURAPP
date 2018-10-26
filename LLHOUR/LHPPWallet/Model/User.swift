//
//  User.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/18/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwiftyJSON

private let authResponseParam = UserAuthAPIParameters.Response.Auth.self

private let dob         = authResponseParam.dob.rawValue
private let gender      = authResponseParam.gender.rawValue
private let countryCode = authResponseParam.countryCode.rawValue
private let mobile      = authResponseParam.mobile.rawValue
private let mailId      = authResponseParam.mailId.rawValue
private let walletId    = authResponseParam.id.rawValue
private let name        = authResponseParam.name.rawValue
private let shortCode   = authResponseParam.shortCode.rawValue

struct User {
  var ageNsex     : Parameters? = [dob         : String.self,
                                   gender      : String.self]
  
  var contact     : Parameters? = [countryCode : Int.self,
                                   mailId      : String.self,
                                   mobile      : Int.self]
  var walletFamily: Parameters? = [walletId    : Int.self,
                                   name        : String.self,
                                   shortCode   : String.self]
  var walletType  : Parameters? = [walletId    : Int.self,
                                   name        : String.self,
                                   shortCode   : String.self]
  var avatar: String?
  var firstName: String?
  var id: String?
  var lastName: String?
  var preferredName: String?
  var uid: String?
  
  init(json: JSON) {
    ageNsex       = json[authResponseParam.ageNsex.rawValue].dictionaryObject
    contact       = json[authResponseParam.contact.rawValue].dictionaryObject
    walletFamily  = json[authResponseParam.walletFamily.rawValue].dictionaryObject
    walletType    = json[authResponseParam.walletType.rawValue].dictionaryObject
    avatar        = json[authResponseParam.avatar.rawValue].string
    firstName     = json[authResponseParam.firstName.rawValue].string
    id            = json[authResponseParam.id.rawValue].string
    lastName      = json[authResponseParam.lastName.rawValue].string
    preferredName = json[authResponseParam.preferredName.rawValue].string
    uid           = json[authResponseParam.uid.rawValue].string
  }
}
