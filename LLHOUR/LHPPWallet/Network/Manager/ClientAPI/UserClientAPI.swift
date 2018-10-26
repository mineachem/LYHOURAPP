//
//  ClientAPI.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/18/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias ClientAPICompletionBlock = (_ values: Any?, _ error: String?) -> Void

struct UserClientAPI {
  
  func request(userEndpoint: UserEndpoint, completion: @escaping ClientAPICompletionBlock) {
    
    var endpoint: UserEndpoint
    var responseType: APIResponseType
    
    switch userEndpoint {
    case .initial(let parameters):
      endpoint = UserEndpoint.initial(parameters: parameters)
      responseType = .initialize
    case .challenge(let parameters):
      endpoint = UserEndpoint.challenge(parameters: parameters)
      responseType = .challenge
    case .register(let parameters):
      endpoint = UserEndpoint.register(parameters: parameters)
      responseType = .register
    case .auth(let parameters):
      endpoint = UserEndpoint.auth(parameters: parameters)
      responseType = .auth
    case .updateCredential(let parameters):
      endpoint = UserEndpoint.updateCredential(parameters: parameters)
      responseType = .updateCredential
    }
    
    if responseType == .updateCredential {
      Alamofire.request(endpoint).debugLog().validate(statusCode: 200...600).responseData { (response) in
        response.printResponse()
        guard let statusCode = response.response?.statusCode else { return }
        if statusCode != 200 {
          completion(nil, "You can't use the old PIN. Please choose a new one.")
        } else {
          completion(nil, nil)
        }
      }
    } else {
      handleNetworkRequest(userEndpoint: endpoint, responseType: responseType) { (response, error) in
        completion(response, error)
      }
    }
  }
}

private extension UserClientAPI {
  enum APIResponseType {
    case initialize
    case challenge
    case register
    case auth
    case updateCredential
  }
  
  func handleNetworkRequest(userEndpoint: UserEndpoint, responseType: APIResponseType, completion: @escaping ClientAPICompletionBlock) {
    Alamofire.request(userEndpoint).debugLog().validate(statusCode: 200...600).responseJSON { (response) in
      self.handleNetworkResponse(error: response.error, dataResponse: response, apiResponse: responseType, completion: { (values, error) in
        
        switch userEndpoint {
        case .initial:
          if let initResponse = values as? InitResponse {
            completion(initResponse, nil)
          } else {
            completion(nil, error)
          }
        case .challenge:
          if let jarvisInitResponse = values as? ChallengeResponse {
            completion(jarvisInitResponse, nil)
          } else {
            completion(nil, error)
          }
        case .register:
          if let registerResponse = values as? RegisterResponse {
            completion(registerResponse, nil)
          } else {
            completion(nil, error)
          }
        case .auth:
          if let authResponse = values as? AuthResponse {
            completion(authResponse, nil)
          } else {
            completion(nil, error)
          }
        case .updateCredential:
          break
        }
      })
    }
  }
  
  func handleNetworkResponse(error: Error?, dataResponse: DataResponse<Any>, apiResponse: APIResponseType, completion: @escaping ClientAPICompletionBlock) {
    
    if let error = dataResponse.error as? URLError {
      print(error.code)
      
      if error.code == URLError.Code.notConnectedToInternet {
        completion(nil, "You appear to be offline. Please check your internet connection.")
      } else if error.code == URLError.Code.timedOut {
        completion(nil, "Service is not reachable at the moment. Please try again later.")
      }
      
      return
    }
    
    dataResponse.printResponse()
    guard let statusCode = dataResponse.response?.statusCode else { return }
    switch statusCode {
    case 200..<300:
      self.handleSuccessResponse(with: dataResponse, response: apiResponse) { (jsonDictionary) in
        completion(jsonDictionary, nil)
      }
    default:
      self.handleErrorResponse(with: statusCode, response: dataResponse) { (error) in
        completion(nil, error)
      }
    }
  }
  
  func handleSuccessResponse(with dataResponse: DataResponse<Any>, response: APIResponseType, completion: @escaping (_ values: Any?) -> Void) {
    guard let jsonDictionary = dataResponse.result.value as? JSONDictionary else { return }
    switch response {
    case .initialize:
      let response = InitResponse(json: JSON(jsonDictionary))
      completion(response)
    case .challenge:
      let response = ChallengeResponse(json: JSON(jsonDictionary))
      completion(response)
    case .register:
      let response = RegisterResponse(json: JSON(jsonDictionary))
      completion(response)
    case .auth:
      let response = AuthResponse(json: JSON(jsonDictionary))
      completion(response)
    case .updateCredential:
      completion(nil)
    }
  }
  
  func handleErrorResponse(with statusCode: Int, response: DataResponse<Any>, completion: (_ error: String?) -> Void) {
    let (_, errorMessage) = handleErrorMessage(with: response)
    completion(errorMessage)
//    switch statusCode {
//    case 400:
//      if jarvisError?.httpStatusCode == JARVISHTTPStatusCode.badRequest.rawValue &&
//        jarvisError?.source == JARVISHTTPSource.challengeProtocol.rawValue {
//        completion("Verification Codes are not correct. Please try again")
//      } else if jarvisError?.httpStatusCode == JARVISHTTPStatusCode.badRequest.rawValue &&
//        jarvisError?.source == JARVISHTTPSource.registration.rawValue {
//        completion("Invalid Last Name")
//      } else {
//        completion(errorMessage)
//      }
//    case 403:
//      if jarvisError?.httpStatusCode == JARVISHTTPStatusCode.forbidden.rawValue &&
//        jarvisError?.source == JARVISHTTPSource.jarvis.rawValue {
//        completion("Your Full Name is not correct. Please provide at least one First Name and one Last Name.")
//      } else {
//        completion(errorMessage)
//      }
//    case 404:
//      completion("User does not exist. Please try again or create a new account.")
//    case 412:
//      completion("Password should contain at least 1 uppercase and 1 lowercase and 1 special character and it should have at least 8 characters long")
//    case 417:
//      if jarvisError?.httpStatusCode == JARVISHTTPStatusCode.expectationFailed.rawValue &&
//        jarvisError?.source == JARVISHTTPSource.initializationStep1.rawValue {
//        completion("This Mobile Number already exists. Please enter a new number.")
//      } else {
//        completion(errorMessage)
//      }
//    case 500:
//      completion("Server does not response at the moment. Please try again later")
//    default:
//      completion(errorMessage)
//    }
  }
  
  func handleErrorMessage(with response: DataResponse<Any>) -> (JARVISError?, String?) {
    guard let error = response.result.value else { return (nil, nil) }
    let jarvisError = JARVISError(json: JSON(error))
    if let message = jarvisError.messages?.first {
      return (jarvisError, message)
    } else if let exception = jarvisError.innerExceptions?.first {
      return (jarvisError, exception)
    } else {
      return (jarvisError, "Something went wrong. Please try again later.")
    }
  }
}
