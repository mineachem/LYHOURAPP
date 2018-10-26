//
//  Request+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/23/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Alamofire

extension Request {
  public func debugLog() -> Self {
    #if DEBUG
    debugPrint(self)
    #endif
    return self
  }
}
