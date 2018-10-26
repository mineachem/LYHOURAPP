//
//  TransactionEndPoint.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import Alamofire

enum TransactionEndPoint: APIConfiguration {
  
  case balanceInquiry(parameters: Parameters)
  case addWallet(parameters: Parameters)
  
   // MARK: - Path
  var path: String {
    switch self {
    case .balanceInquiry:
      return "/balance"
    case .addWallet:
      return "/addWallet"
    }
  }
  
  // MARK: - HTTPMethod
  var method: HTTPMethod {
    switch self {
    case .balanceInquiry:
      return .post
    case .addWallet:
      return .post
    }
  }
  
  // MARK: - Parameters
  var parameters: Parameters? {
    switch self {
    case .balanceInquiry(let parameters):
      return parameters
    case .addWallet(let parameters):
      return parameters
    }
  }
  
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try K.UATServer.baseURL.asURL()
    return try BaseEndPoint.asURLRequest(url, path: path, method: method, parameters: parameters)
  }
}
