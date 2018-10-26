//
//  String+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/23/18.
//  Copyright © 2018 IG. All rights reserved.
//

import CryptoSwift

enum ImageFormat{
  case png
  case jpegData(CGFloat)
}

extension String {
  
  func trimWhiteSpaces() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var toHex64String: String {
    return padding(toLength: 64, withPad: "F", startingAt: 0)
  }
  
  func toHmacMD5(with key: String) -> String {
    do {
      let hmac = try HMAC(key: key, variant: .md5).authenticate(bytes)
      let data = Data(bytes: hmac)
      return data.base64EncodedString()
    } catch let error {
      print(error.localizedDescription)
    }
    return ""
  }
  
  func convertImageToBase64String(format:ImageFormat,image: UIImage) -> String?{
    var imageData:Data?
    switch format{
    case .png:imageData = image.pngData()
    case .jpegData(let compression): image.jpegData(compressionQuality: compression)
    }
    return imageData?.base64EncodedString()
  }
  
  func base64StringToByteArray() -> [UInt8]? {
    if let data = NSData(base64Encoded: self, options: .init(rawValue: 8)) {
      var bytes = [UInt8](repeating: 0, count: data.length)
      data.getBytes(&bytes, length: bytes.count)
      return bytes
    }
    return nil // Invalid input
  }
  
  func hexStringToBytes() -> [UInt8]? {
    let length = self.count
    if length & 1 != 0 {
      return nil
    }
    var bytes = [UInt8]()
    bytes.reserveCapacity(length/2)
    var index = self.startIndex
    for _ in 0..<length/2 {
      let nextIndex = self.index(index, offsetBy: 2)
      if let b = UInt8(self[index..<nextIndex], radix: 16) {
        bytes.append(b)
      } else {
        return nil
      }
      index = nextIndex
    }
    return bytes
  }
  
  func utcToDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "ICT +7")
    
    if let dt = dateFormatter.date(from: self) {
      dateFormatter.timeZone = TimeZone.current
      dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm:ss"
      return dateFormatter.string(from: dt)
    }
    return Date.javisDateFormat
  }
}
