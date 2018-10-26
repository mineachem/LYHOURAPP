//
//  UserAPIService.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/18/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

protocol UserAPIProtocol: UserAPIBaseProtocol {
  
  func initJARVIS(with paramerters: Parameters, completion: @escaping (_ values: InitResponse?, _ error: String?) -> Void)
  
  func challenge(parameters: Parameters, completion: @escaping (_ values: ChallengeResponse?, _ error: String?) -> Void)
  
  func register(parameters: Parameters, completion: @escaping (_ values: RegisterResponse?, _ error: String?) -> Void)
  
  func auth(parameters: Parameters, completion: @escaping (_ values: AuthResponse?, _ error: String?) -> Void)
  
  func updateCredential(parameters: Parameters, completion: @escaping (_ error: String?) -> Void)
}
