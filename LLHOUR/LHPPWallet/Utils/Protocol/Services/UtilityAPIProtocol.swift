//
//  UtilAPIProtocol.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol UtilityAPIProtocol: UtilityAPIBaseProtocol {
  func fetchOffers(with paramerters: Parameters, completion: @escaping (_ values: Any?, _ error: String?) -> Void)
}
