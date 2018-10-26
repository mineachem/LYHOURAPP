//
//  ChallengeReponse.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ChallengeResponse {
  var fk: String?
  var sk: String?
  var lang: String?
  var timeStamp: String?
  var handle: String?
  
  private let challengeResponseParam = UserAuthAPIParameters.Response.Challenge.self
  
  init(json: JSON) {
    fk            = json[challengeResponseParam.fk.rawValue].string
    sk            = json[challengeResponseParam.sk.rawValue].string
    handle        = json[challengeResponseParam.handle.rawValue].string
    lang          = json[challengeResponseParam.lang.rawValue].string
    timeStamp     = json[challengeResponseParam.timeStamp.rawValue].string
  }
}
