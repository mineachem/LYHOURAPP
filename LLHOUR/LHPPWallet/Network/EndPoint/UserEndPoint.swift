//
//  UserEndPoint.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndpoint: APIConfiguration {
  
  case initial(parameters: Parameters)
  case challenge(parameters: Parameters)
  case register(parameters: Parameters)
  case auth(parameters: Parameters)
  case updateCredential(parameters: Parameters)
  
  // MARK: - Path
  var path: String {
    switch self {
    case .initial:
      return "/init"
    case .challenge:
      return "/challenge"
    case .register:
      return "/register"
    case .auth:
      return "/auth"
    case .updateCredential:
      return "/updateCred"
    }
  }
  
  // MARK: - Parameters
  var parameters: Parameters? {
    switch self {
    case .initial(let parameters):
      return parameters
    case .challenge(let parameters):
      return parameters
    case .register(let parameters):
      return parameters
    case .auth(let parameters):
      return parameters
    case .updateCredential(let parameters):
      return parameters
    }
  }
  
  // MARK: - HTTPMethod
  var method: HTTPMethod {
    switch self {
    case .initial, .challenge, .register, .auth, .updateCredential:
      return .post
    }
  }
  
  // MARK: - URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try K.UATServer.baseURL.asURL()
    return try BaseEndPoint.asURLRequest(url, path: path, method: method, parameters: parameters)
  }
}
