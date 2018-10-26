//
//  Document.swift
//  LHPPWallet
//
//  Created by User on 10/25/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import SwiftyJSON

enum typeDoc:String {
  case passport = "P"
  case nationalID = "N"
  case familyBook = "F"
  case governmentIID = "G"
  case birthCertificate = "B"
  case Other = "O"
}

struct Document {
  let type: typeDoc
  let name: String
  let mime: String
  let data: String
  let gZip: Bool
  
  
  init(type:typeDoc,name:String,mime:String,data:String,gZip:Bool) {
    self.type = type
    self.name = name
    self.mime = mime
    self.data = data
    self.gZip = gZip
  }
}
