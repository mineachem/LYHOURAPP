//
//  UploadingDocumentAPIProtocol.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation
import UIKit
protocol UploadDocAPIProtocol:UploadingDocBaseProtocol {
  
  func uploadDocuments(imageData:Data,parameter: Parameters,completion: @escaping (_ value: UploadAvatarResponse?,_ error: String?) -> Void)
  
  func uploadAvatar(imageData:Data,parameter: Parameters,completion: @escaping (_ value: UploadAvatarResponse?,_ error: String?) -> Void)
  
}
