//
//  UtilityAPI.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct UtilityAPI: UtilityAPIProtocol {
  
  var utilClientAPI: UtilityClientAPI
  
  init(api: UtilityClientAPI) {
    self.utilClientAPI = api
  }
  
  func fetchOffers(with parameters: Parameters, completion: @escaping (Any?, String?) -> Void) {
    utilClientAPI.request(utilEndpoint: .offers(parameters: parameters)) { (values, error) in
      completion(values, error)
    }
  }
}
