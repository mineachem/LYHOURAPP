//
//  Login.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InitResponse {
  var additional: JSON?
  var crp: String?
  var handle: String?
  var ik: String?
  var lang: String?
  var timeStamp: String?
  var signature: String?
  
  private let initResponseParam = UserAuthAPIParameters.Response.Init.self
  
  init(json: JSON) {
    additional    = json[initResponseParam.additional.rawValue]
    crp           = json[initResponseParam.crp.rawValue].string
    handle        = json[initResponseParam.handle.rawValue].string
    ik            = json[initResponseParam.ik.rawValue].string
    lang          = json[initResponseParam.lang.rawValue].string
    timeStamp     = json[initResponseParam.timeStamp.rawValue].string
    signature     = json[initResponseParam.signature.rawValue].string
  }
}
