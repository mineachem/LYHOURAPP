//
//  UploadingDocViewModel.swift
//  LHPPWallet
//
//  Created by User on 10/24/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
struct UploadingAvatarViewModel {
  var handle: String
  var deviceId: String
  var lang: String
  var avatar: Bool
  var documents:[Document]
  var timeStamp: String
  
   private let uploadingDocParam = UploadingDocumentAPIParameters.Request.Upload.self
  
  var parameters: Parameters {
    
    guard let doc = documents.first else { return [:] }
    
    let signatureText = "\(avatar)\(deviceId)\(doc.data)\(doc.gZip)\(doc.mime)\(doc.name)\(doc.type)\(handle)\(lang)\(timeStamp)"
    let signature = JARVISViewModelUtils.generateSignature(with: deviceId, signatureText: signatureText)
    
    return [uploadingDocParam.handle.rawValue : handle,
            uploadingDocParam.avatar.rawValue    : avatar,
            uploadingDocParam.deviceId.rawValue  : deviceId,
            uploadingDocParam.documents.rawValue : documents,
      uploadingDocParam.data.rawValue :  doc.data,
      uploadingDocParam.gZip.rawValue : doc.gZip,
      uploadingDocParam.mime.rawValue : doc.mime,
      uploadingDocParam.name.rawValue : doc.name,
      uploadingDocParam.type.rawValue : doc.type,
      uploadingDocParam.lang.rawValue      : lang,
      uploadingDocParam.timeStamp.rawValue : timeStamp,
      uploadingDocParam.signature.rawValue : signature]
    
  }
  
  //MARK: Initialize
  init(avatar: Bool,deviceId:String,documents:[Document],lang:String,handle: String,timeStamp:String) {
      self.avatar = avatar
      self.deviceId = deviceId
      self.handle = handle
      self.documents = documents
      self.lang = lang
      self.timeStamp = timeStamp.utcToDateString()
  }
}
