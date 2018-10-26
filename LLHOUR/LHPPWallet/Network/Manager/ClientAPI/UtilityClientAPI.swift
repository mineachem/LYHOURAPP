//
//  UtilClientAPI.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/10/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct UtilityClientAPI {
  
  func request(utilEndpoint: UtilityEndPoint, completion: @escaping ClientAPICompletionBlock) {
    var endpoint: UtilityEndPoint
    var responseType: APIResponseType
    
    switch utilEndpoint {
    case .offers(let parameters):
      endpoint = UtilityEndPoint.offers(parameters: parameters)
      responseType = .offers
    }
    
    handleNetworkRequest(utilEndpoint: endpoint, responseType: responseType) { (response, error) in
      completion(response, error)
    }
  }
}

private extension UtilityClientAPI {
  enum APIResponseType {
    case offers
  }
  
  func handleNetworkRequest(utilEndpoint: UtilityEndPoint, responseType: APIResponseType, completion: @escaping ClientAPICompletionBlock) {
    Alamofire.request(utilEndpoint).debugLog().validate(statusCode: 200...600).responseJSON { (response) in
      self.handleNetworkResponse(error: response.error, dataResponse: response, apiResponse: responseType, completion: { (values, error) in
        
        if let err = error {
          completion(nil, err)
          return
        }
        
        switch utilEndpoint {
        case .offers:
          completion(values, nil)
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
    case .offers:
      completion(jsonDictionary)
    }
  }
  
  func handleErrorResponse(with statusCode: Int, response: DataResponse<Any>, completion: (_ error: String?) -> Void) {
    let (_, errorMessage) = handleErrorMessage(with: response)
    completion(errorMessage)
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
