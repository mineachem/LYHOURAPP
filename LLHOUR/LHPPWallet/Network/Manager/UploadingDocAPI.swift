//
//  UploadingDocAPI.swift
//  LHPPWallet
//
//  Created by User on 10/24/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import UIKit

struct UploadingDocAPI:UploadDocAPIProtocol {
  var uploadingDocClientAPI: UploadingDocumentClientAPI
  
  init(api: UploadingDocumentClientAPI) {
   self.uploadingDocClientAPI = api
  }
  
  func uploadDocuments(imageData:Data,parameter: Parameters, completion: @escaping (UploadAvatarResponse?, String?) -> Void) {
    
    uploadingDocClientAPI.upload(imageData: imageData, uploadingClientAPI: .uploadDocument(parameters: parameter)) { (values, error) in
      completion(values as? UploadAvatarResponse,error)
    }
  }
  
  func uploadAvatar(imageData:Data,parameter: Parameters, completion: @escaping (UploadAvatarResponse?, String?) -> Void) {
    
    uploadingDocClientAPI.upload(imageData: imageData, uploadingClientAPI: .uploadAvatar(parameters: parameter)) { (values, error) in
      completion(values as? UploadAvatarResponse,error)
    }
  }
  
  
}
