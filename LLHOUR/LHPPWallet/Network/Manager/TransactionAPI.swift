//
//  TransactionAPI.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct TransactionAPI: TransactionAPIProtocol {
  
  var transactionClientAPI: TransactionClientAPI
  
  init(api: TransactionClientAPI) {
    self.transactionClientAPI = api
  }
  
  func inquireBalances(parameters: Parameters, completion: @escaping (BalanceInquiryReponse?, String?) -> Void) {
    transactionClientAPI.request(transactionEndPoint: .balanceInquiry(parameters: parameters)) { (values, error) in
      completion(values as? BalanceInquiryReponse, error)
    }
  }
  
  func addWallet(parameters: Parameters, completion: @escaping (AddWalletResponse?, String?) -> Void) {
    transactionClientAPI.request(transactionEndPoint: .addWallet(parameters: parameters)) { (values, error) in
      completion(values as? AddWalletResponse, error)
    }
  }
}
