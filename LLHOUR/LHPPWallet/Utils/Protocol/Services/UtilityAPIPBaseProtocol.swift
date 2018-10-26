//
//  UtilAPIProtocol.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol UtilityAPIBaseProtocol {
  var utilClientAPI: UtilityClientAPI { get set }
  init(api: UtilityClientAPI)
}
