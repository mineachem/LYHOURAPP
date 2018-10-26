//
//  InitViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

// For Register
struct InitViewModel {
  let deviceId: String
  let program: String
  let countryCode: Int
  let mobile: Int
  let lang: String
  let timeStamp: String
  let userName: String
  
  private let initRequestParam = UserAuthAPIParameters.Request.Init.self
  
  var parameters: Parameters {
    let signatureText: String
    let signature: String
    // ----- REGISTER FLOW ----- //
    if userName.isEmpty {
      signatureText = "\(countryCode)\(deviceId)\(lang)\(mobile)\(program)\(timeStamp)"
      signature = JARVISViewModelUtils.generateSignature(with: deviceId, signatureText: signatureText)
      return [  initRequestParam.program.rawValue     : program,
                initRequestParam.deviceId.rawValue    : deviceId,
                initRequestParam.countryCode.rawValue : countryCode,
                initRequestParam.mobile.rawValue      : mobile,
                initRequestParam.timeStamp.rawValue   : timeStamp,
                initRequestParam.lang.rawValue        : lang,
                initRequestParam.signature.rawValue   : signature
      ]
    } else {
      // ----- LOGIN FLOW ----- //
      signatureText = "\(deviceId)\(lang)\(program)\(timeStamp)\(userName)"
      signature = JARVISViewModelUtils.generateSignature(with: deviceId, signatureText: signatureText)
      return [  initRequestParam.program.rawValue   : program,
                initRequestParam.deviceId.rawValue  : deviceId,
                initRequestParam.userName.rawValue  : userName,
                initRequestParam.timeStamp.rawValue : timeStamp,
                initRequestParam.lang.rawValue      : lang,
                initRequestParam.signature.rawValue : signature
      ]
    }
  }
  
  init(deviceId: String, userName: String? = nil, countryCode: Int? = nil, mobile: Int? = nil, lang: String, program: String, timeStamp: String) {
    self.deviceId = deviceId
    self.program = program
    self.countryCode = countryCode ?? 0
    self.mobile = mobile ?? 0
    self.lang = lang
    self.timeStamp = timeStamp
    self.userName = userName ?? ""
  }
}
