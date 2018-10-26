//
//  UploadingDocumentEndPoint.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire

enum UploadingDocumentEndPoint: APIConfiguration {
  case uploadDocument(parameters: Parameters)
  case uploadAvatar(parameters:Parameters)
  
  var path: String {
    switch self {
    case .uploadDocument:
      return "/upload"
    case .uploadAvatar:
      return "/upload"
    }
  }
  var method: HTTPMethod {
    switch self {
    case .uploadDocument:
      return .post
    case .uploadAvatar:
      return .post
    }
  }
  var parameters: Parameters?{
    switch self {
    case .uploadDocument(let parameters):
      return parameters
    case .uploadAvatar(let parameters):
      return parameters
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try K.UATServer.baseURL.asURL()
    return try BaseEndPoint.asURLRequest(url, path: path, method: method, parameters: parameters)
  }
  
  
}
