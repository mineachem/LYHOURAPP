//
//  TransactionClientAPI.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/27/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias TransactionAPICompletionBlock = (_ values: Any?, _ error: String?) -> Void

struct TransactionClientAPI {
  
  func request(transactionEndPoint: TransactionEndPoint, completion: @escaping TransactionAPICompletionBlock) {
    var endpoint: TransactionEndPoint
    var responseType: APIResponseType
    
    switch transactionEndPoint {
    case .balanceInquiry(let parameters):
      endpoint = TransactionEndPoint.balanceInquiry(parameters: parameters)
      responseType = .balanceInquiry
    case .addWallet(let parameters):
      endpoint = TransactionEndPoint.addWallet(parameters: parameters)
      responseType = .addWallet
    }
    
    handleNetworkRequest(transactionEndPoint: endpoint, responseType: responseType) { (response, error) in
      completion(response, error)
    }
  }
}

private extension TransactionClientAPI {
  enum APIResponseType {
    case balanceInquiry
    case addWallet
  }
  
  func handleNetworkRequest(transactionEndPoint: TransactionEndPoint, responseType: APIResponseType, completion: @escaping ClientAPICompletionBlock) {
    Alamofire.request(transactionEndPoint).debugLog().validate(statusCode: 200...600).responseJSON { (response) in
      self.handleNetworkResponse(error: response.error, dataResponse: response, apiResponse: responseType, completion: { (values, error) in
        
        switch transactionEndPoint {
        case .balanceInquiry:
          if let balanceInquiryResponse = values as? BalanceInquiryReponse {
            completion(balanceInquiryResponse, nil)
          } else {
            completion(nil, error)
          }
        case .addWallet:
          if let addWalletResponse = values as? AddWalletResponse {
            completion(addWalletResponse, nil)
          } else {
            completion(nil, error)
          }
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
    case .balanceInquiry:
      let balanceResponse = BalanceInquiryReponse(json: JSON(jsonDictionary))
      completion(balanceResponse)
    case .addWallet:
      let addWalletResponse = AddWalletResponse(json: JSON(jsonDictionary))
      completion(addWalletResponse)
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
