//
//  JARVISAPIRequest.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/25/18.
//  Copyright © 2018 IG. All rights reserved.
//

import CryptoSwift

struct JARVISViewModelUtils {
  
  // MARK: - Generate Signature Key
  static func generateSignatureKey(with bytes: [UInt8]) -> String {
    debugPrint("Signature Key: \(bytes.toHexString().uppercased())")
    return bytes.toHexString().uppercased()
  }
  
  // MARK: - Generate Signature
  static func generateSignature(with key: String, signatureText: String) -> String {
    debugPrint("Signature Text: \(signatureText)")
    debugPrint("Signature: \(signatureText.toHmacMD5(with: key))")
    return signatureText.toHmacMD5(with: key)
  }
  
  // MARK: - Generate Hex String 64 digit
  static func convertToHex64DigitKey(with text: String) -> String {
    debugPrint("Encryption Key: \(text.toHex64String)")
    // Add `F` to make it 64 Digits to make KEY
    return text.toHex64String
  }
  
  
  
  // MARK: - Generate Encryption/Decryption Key
  static func generateEnDecryptionKeys(with bytes: [UInt8]) -> [UInt8] {
    debugPrint("Encryption/Decryption Key: \(bytes.toHexString().uppercased().toHex64String.hexStringToBytes() ?? [])")
    return bytes.toHexString().uppercased().toHex64String.hexStringToBytes() ?? []
  }
  
  // MARK: - Decryption
  static func decrypt(values: [UInt8], withKey key: [UInt8], withIv iv: [UInt8]) -> [UInt8]? {
    do {
      let decryptedVal = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(values)
      debugPrint("Decrypted Value: \(decryptedVal)")
      return decryptedVal
    } catch {
      debugPrint(error.localizedDescription)
    }
    return nil
  }
  
  // MARK: - Encryption
  static func encrypt(values: [UInt8], withKey key: [UInt8], withIv iv: [UInt8]) -> String? {
    do {
      let encryptedVal = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(values).toBase64()
      debugPrint("Encrypted Value: \(encryptedVal ?? "Not able to encrypt")")
      return encryptedVal
    } catch {
      debugPrint(error.localizedDescription)
    }
    return nil
  }
}
