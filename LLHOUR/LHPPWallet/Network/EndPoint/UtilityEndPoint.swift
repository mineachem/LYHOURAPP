//
//  UtilityEndPoint.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire

enum UtilityEndPoint: APIConfiguration {
  case offers(parameters: Parameters)
  
  // MARK: - Path
  var path: String {
    switch self {
    case .offers:
      return "/offers/EN"
    }
  }
  
  // MARK: - Parameters
  var parameters: Parameters? {
    switch self {
    case .offers(let parameters):
      return parameters
    }
  }
  
  // MARK: - HTTPMethod
  var method: HTTPMethod {
    switch self {
    case .offers:
      return .get
    }
  }
  
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try K.UATServer.baseURL.asURL()
    return try BaseEndPoint.asURLRequest(url, path: path, method: method, parameters: parameters)
  }
}
