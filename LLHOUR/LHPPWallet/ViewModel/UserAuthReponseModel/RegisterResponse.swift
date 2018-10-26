//
//  RegisterResponse.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RegisterResponse {
  var handle: String?
  var id: String?
  var lang: String?
  var sk: String?
  var timeStamp: String?
  var uid: String?
  
  private let registerResponseParam = UserAuthAPIParameters.Response.Register.self
  
  init(json: JSON) {
    handle        = json[registerResponseParam.handle.rawValue].string
    id            = json[registerResponseParam.id.rawValue].string
    lang          = json[registerResponseParam.lang.rawValue].string
    sk            = json[registerResponseParam.sk.rawValue].string
    timeStamp     = json[registerResponseParam.timeStamp.rawValue].string
    uid           = json[registerResponseParam.uid.rawValue].string
  }
}
