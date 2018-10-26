//
//  UploadingDocuments.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

enum UploadingDocumentAPIParameters {
  enum Request {
    enum Upload:String {
      case handle      = "_handle"
      case deviceId    = "_deviceId"
      case avatar      = "_avatar"
      case documents   = "_documents"
      case type        = "_type"
      case name        = "_name"
      case mime        = "_mime"
      case data        = "_data"
      case gZip        = "_gZip"
      case lang        = "_lang"
      case timeStamp   = "_timeStamp"
      case signature   = "_signature"
      
    }
  }
  
  enum Response {
    enum Upload:String {
      case handle      = "_handle"
      case lang        = "_lang"
      case timeStamp   = "_timeStamp"
      case signature   = "_signature"
      case files      = "_files"
      case type        = "_type"
      case path        = "_path"
    }
  }
}
