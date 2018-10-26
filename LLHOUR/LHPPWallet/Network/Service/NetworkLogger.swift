//
//  NetworkLogger.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation

struct NetworkLogger {
  static func log(request: URLRequest) {
    
    print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
    defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
    
    let urlAsString = request.url?.absoluteString ?? ""
    let urlComponents = URLComponents(string: urlAsString)
    
    let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
    let path = "\(urlComponents?.path ?? "")"
    let query = "\(urlComponents?.query ?? "")"
    let host = "\(urlComponents?.host ?? "")"
    
    var logOutput = """
    \(urlAsString) \n\n
    \(method) \(path)?\(query) HTTP/1.1 \n
    HOST: \(host)\n
    """
    for (key, value) in request.allHTTPHeaderFields ?? [:] {
      logOutput += "\(key): \(value) \n"
    }
    if let body = request.httpBody {
      logOutput += "\n \(String(data: body, encoding: .utf8) ?? "")"
    }
    print(logOutput)
  }
  
  static func log(response: URLResponse) {}
}
