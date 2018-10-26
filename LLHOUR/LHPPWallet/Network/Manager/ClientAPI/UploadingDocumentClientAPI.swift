//
//  UploadingDocumentAPI.swift
//  LHPPWallet
//
//  Created by User on 10/22/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias UploadingDocumentAPICompletionBlock = (_ values: Any?, _ error: String?) -> Void

struct UploadingDocumentClientAPI{
  
  func upload(imageData:Data,uploadingClientAPI: UploadingDocumentEndPoint,completion: @escaping UploadingDocumentAPICompletionBlock){
    var endPoint:UploadingDocumentEndPoint
    var responseType: APIResponseType
    
    switch uploadingClientAPI {
    case .uploadDocument(let parameters):
      endPoint = UploadingDocumentEndPoint.uploadDocument(parameters: parameters)
      responseType = .uploadDocument
    case .uploadAvatar(let parameters):
      endPoint = UploadingDocumentEndPoint.uploadAvatar(parameters: parameters)
      responseType = .uploadAvatar
    }
    
    handleNetworkRequest(imageData:imageData,uploadingDocumentEndPoint: endPoint, responseType: responseType) { (response, error) in
      completion(response,error)
    }
  }
}

extension UploadingDocumentClientAPI {
  enum APIResponseType {
    case uploadDocument
    case uploadAvatar
  }
  
  func handleNetworkRequest(imageData:Data,uploadingDocumentEndPoint: UploadingDocumentEndPoint, responseType: APIResponseType, completion: @escaping ClientAPICompletionBlock) {
    
    Alamofire.upload(multipartFormData: { (multipartFromdata) in
      multipartFromdata.append(imageData, withName: "photo", mimeType: "image/jpeg")
    }, with: uploadingDocumentEndPoint) { (encodingResult) in
      switch encodingResult {
      case .success(let upload,_,_):
        upload.debugLog().validate(statusCode: 200...600)
          upload.responseJSON(completionHandler: { (response) in
            self.handleNetworkResponse(error: response.error, dataResponse: response, apiResponse: responseType, completion: { (values, error) in
              switch uploadingDocumentEndPoint {
              case .uploadDocument:
                break
              case .uploadAvatar:
                if let uploadAvatar = values as? UploadAvatarResponse {
                  completion(uploadAvatar,nil)
                }else {
                  completion(nil,error)
                }
              }
            })
          })
      case .failure(let encodingError):
        print("failed")
        completion(nil, encodingError.localizedDescription)
      }
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
    guard let statusCode = dataResponse.response?.statusCode else {return}
    switch statusCode {
    case 200..<300:
      self.handleSuccessResponse(with: dataResponse, response: apiResponse) { (jsonDictionary) in
        completion(jsonDictionary,nil)
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
    case .uploadDocument:
      break
    case .uploadAvatar:
      let uploadAvatarResponse = UploadAvatarResponse(json: JSON(jsonDictionary))
      completion(uploadAvatarResponse)
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
