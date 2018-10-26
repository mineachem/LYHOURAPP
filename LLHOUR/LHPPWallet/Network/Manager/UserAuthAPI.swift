//
//  JarvisUserAuthAPIManager.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct UserAuthAPI: UserAPIProtocol {
  
  var userClientAPI: UserClientAPI
  
  init(api: UserClientAPI) {
    self.userClientAPI = api
  }
  
  func initJARVIS(with parameters: Parameters, completion: @escaping (_ values: InitResponse?, _ error: String?) -> Void) {
    userClientAPI.request(userEndpoint: .initial(parameters: parameters)) { (response, error) in
      completion(response as? InitResponse, error)
    }
  }
  
  func challenge(parameters: Parameters, completion: @escaping (_ values: ChallengeResponse?, _ error: String?) -> Void) {
    userClientAPI.request(userEndpoint: .challenge(parameters: parameters)) { (response, error) in
      completion(response as? ChallengeResponse, error)
    }
  }
  
  func register(parameters: Parameters, completion: @escaping (_ values: RegisterResponse?, _ error: String?) -> Void) {
    userClientAPI.request(userEndpoint: .register(parameters: parameters)) { (response, error) in
      completion(response as? RegisterResponse, error)
    }
  }
  
  func auth(parameters: Parameters, completion: @escaping (_ values: AuthResponse?, _ error: String?) -> Void) {
    userClientAPI.request(userEndpoint: .auth(parameters: parameters)) { (response, error) in
      completion(response as? AuthResponse, error)
    }
  }
  
  func updateCredential(parameters: Parameters, completion: @escaping (_ error: String?) -> Void) {
    userClientAPI.request(userEndpoint: .updateCredential(parameters: parameters)) { (_, error) in
      completion(error)
    }
  }
}
