//
//  JarvisError.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwiftyJSON

enum JARVISHTTPStatusCode: String {
  case badRequest = "BadRequest"
  case expectationFailed = "ExpectationFailed"
  case forbidden = "Forbidden"
  case preconditionFailed = "PreconditionFailed"
}

enum JARVISHTTPSource: String {
  case authentication = "Authentication"
  case challengeProtocol = "Challenge Protocol"
  case initializationStep1 = "Initialization Step 1"
  case jarvis = "JARViS"
  case registration = "Registration"
}

struct JARVISError {
  
  var httpStatusCode: String?
  var source: String?
  var messages: [String]?
  var innerExceptions: [String]?
  
  init(json: JSON) {
    self.httpStatusCode = json["httpStatusCode"].string
    self.source = json["source"].string
    self.messages = json["message"].arrayObject as? [String]
    self.innerExceptions = json["innerException"].arrayObject as? [String]
  }
}
