//
//  APIConfiguration.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Parameters? { get }
}
