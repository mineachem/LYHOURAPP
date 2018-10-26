//
//  Constant.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]
typealias Parameters = JSONDictionary
typealias ErrorDictionary = JSONDictionary

//swiftlint:disable type_name
struct K {
  struct UATServer {
    static let baseURL = "https://jarvis-uat.lyhourpay.com:7443"
  }
  
  struct APIParameterKey {
    static let password = "password"
    static let email = "email"
  }
}

enum HTTPHeaderField: String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
  case acceptType = "Accept"
  case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
  case json = "application/json"
}
