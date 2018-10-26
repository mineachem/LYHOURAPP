//
//  APIProtocol.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol UserAPIBaseProtocol {
  var userClientAPI: UserClientAPI { get set }
  init(api: UserClientAPI)
}
