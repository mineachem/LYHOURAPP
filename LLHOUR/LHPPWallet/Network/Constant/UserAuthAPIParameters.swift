//
//  JARVISParameters.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation

enum UserAuthAPIParameters {
  enum Request {
    enum Init: String {
      case countryCode      = "_countryCode"
      case deviceId         = "_deviceId"
      case mobile           = "_mobile"
      case program          = "_program"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
      case userName         = "_userName"
    }
    
    enum Challenge: String {
      case crv              = "_crv"
      case deviceId         = "_deviceId"
      case handle           = "_handle"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
    }
    
    enum Register: String {
      case deviceId         = "_deviceId"
      case handle           = "_handle"
      case lang             = "_lang"
      case firstName        = "_firstName"
      case middleName       = "_middleName"
      case lastName         = "_lastName"
      case preferredName    = "_preferredName"
      case gender           = "_gender"
      case dob              = "_dob"
      case username         = "_userName"
      case userPass         = "_userPass"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
      case type             = "_type"
    }
    
    enum Auth: String {
      case handle       = "_handle"
      case deviceId     = "_deviceId"
      case userName     = "_userName"
      case userPass     = "_userPass"
      case lang         = "_lang"
      case timeStamp    = "_timeStamp"
      case onlyAuth     = "_onlyAuth"
      case pin          = "_pin"
      case signature    = "_signature"
    }
    
    enum UpdateCredential: String {
      case handle       = "_handle"
      case deviceId     = "_deviceId"
      case userPass     = "_userPass"
      case pin          = "_pin"
      case tpin         = "_tpin"
      case authByOTP    = "_authByOTP"
      case timeStamp    = "_timeStamp"
      case lang         = "_lang"
      case signature    = "_signature"
    }
  }
}

extension UserAuthAPIParameters {
  enum Response {
    enum Init: String {
      case additional       = "_additional"
      case crp              = "_crp"
      case handle           = "_handle"
      case ik               = "_ik"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
    }
    
    enum Challenge: String {
      case fk               = "_fk"
      case sk               = "_sk"
      case handle           = "_handle"
      case lang             = "_lang"
      case timeStamp        = "_timeStamp"
      case signature        = "_signature"
    }
    
    enum Register: String {
      case handle       = "_handle"
      case id           = "_id"
      case lang         = "_lang"
      case sk           = "_sk"
      case timeStamp    = "_timeStamp"
      case uid          = "_uid"
    }
    
    enum Auth: String {
      case account      = "_account"
      case accounts     = "_accounts"
      case acNo         = "_acNo"
      case proxy        = "_proxy"
      case value        = "_value"
      case active       = "_active"
      case balance      = "_balance"
      case balances      = "_balances"
      case available    = "_available"
      case blocked      = "_blocked"
      case ledger       = "_ledger"
      case currency     = "_currency"
      case isDefault    = "_default"
      case ofWallet     = "_ofWallet"
      case authBy       = "_authBy"
      case otp          = "_otp"
      case tPIN         = "_tPIN"
      case cards        = "_cards"
      case decimal      = "_decimal"
      case id           = "_id"
      case handle       = "_handle"
      case lang         = "_lang"
      case others       = "_others"
      case favorite     = "_favorite"
      case rec          = "_rec"
      case txn          = "_txn"
      case kyc          = "_kyc"
      case byCard       = "_byCard"
      case on           = "_on"
      case state        = "_state"
      case loyalty      = "_loyalty"
      case referral     = "_referral"
      case role         = "_role"
      case signature    = "_signature"
      case sk           = "_sk"
      case timeStamp    = "_timeStamp"
      case txnRule      = "_txnRule"
      case user         = "_user"
      case ageNsex      = "_ageNsex"
      case dob          = "_dob"
      case gender       = "_gender"
      case avatar       =  "_avatar"
      case contact      = "_contact"
      case countryCode  = "_countryCode"
      case mailId       = "_mailId"
      case mobile       = "_mobile"
      case firstName    = "_firstName"
      case lastName     = "_lastName"
      case preferredName = "_preferredName"
      case uid          = "_uid"
      case walletFamily = "_walletFamily"
      case name         = "_name"
      case shortCode    = "_shortCode"
      case walletType   = "_walletType"
    }
  }
}
