//
//  TransactAPIProtocol.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/27/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol TransactionAPIBaseProtocol {
  var transactionClientAPI: TransactionClientAPI { get set }
  init(api: TransactionClientAPI)
}
