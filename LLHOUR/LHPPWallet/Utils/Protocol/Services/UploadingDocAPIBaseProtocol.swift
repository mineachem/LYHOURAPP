//
//  UploadingDocumentAPIBaseProtocol.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol UploadingDocBaseProtocol {
  var uploadingDocClientAPI: UploadingDocumentClientAPI { get set }
  init(api: UploadingDocumentClientAPI)
}
