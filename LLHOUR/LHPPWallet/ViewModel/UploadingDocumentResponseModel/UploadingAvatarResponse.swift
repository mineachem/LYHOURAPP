//
//  UploadingAvatarViewModel.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON
private let uploadAvatarResponse  = UploadingDocumentAPIParameters.Response.Upload.self
//enum TypeIdentifier: Int {
//  case Passport = 0,NationalID,FamilyBook,GovernmentIssued,BirthCertificate,Others
//}

struct UploadAvatarResponse {
  var handle: String
  var lang: String
  var timeStamp: String
  var signature: String
  var files: JSONDictionary?
  var type: Int
  var path: String
  
  init(json: JSON) {
    
    handle     = json[uploadAvatarResponse.handle.rawValue].stringValue
    lang       = json[uploadAvatarResponse.lang.rawValue].stringValue
    timeStamp  = json[uploadAvatarResponse.timeStamp.rawValue].stringValue
    signature  = json[uploadAvatarResponse.signature.rawValue].stringValue
    files      = json[uploadAvatarResponse.files.rawValue].dictionaryObject
    if let file = files {
      type = file[uploadAvatarResponse.type.rawValue] as! Int
      path = file[uploadAvatarResponse.path.rawValue] as! String
    }
    type       = json[uploadAvatarResponse.type.rawValue].intValue
    path       = json[uploadAvatarResponse.path.rawValue].stringValue
 }
}
