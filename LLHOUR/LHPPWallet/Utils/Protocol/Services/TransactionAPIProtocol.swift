//
//  TransactionAPIProtocol.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol TransactionAPIProtocol: TransactionAPIBaseProtocol {
  func inquireBalances(parameters: Parameters, completion: @escaping (_ values: BalanceInquiryReponse?, _ error: String?) -> Void)
  
  func addWallet(parameters: Parameters, completion: @escaping (_ values: AddWalletResponse?, _ error: String?) -> Void)
}
