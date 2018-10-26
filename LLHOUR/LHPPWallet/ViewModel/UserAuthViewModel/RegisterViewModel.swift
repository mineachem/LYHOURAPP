//
//  RegiterViewModel.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/26/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

struct RegisterViewModel {
  // MARK: - Public
  let fk: String
  let deviceId: String
  let handle: String
  let lang: String
  let fullName: Name
  let preferredName: String
  let gender: String
  let dob: String
  let userName: String
  let userPass: String
  let timeStamp: String
  let type: Int
  let challengeKey: String
  
  private let registRequestParam = UserAuthAPIParameters.Request.Register.self
  
  var parameters: Parameters {
    guard let encryptedPassword = encryptedPassword else {
      debugPrint("Encrypted Password is not valid")
      return [:]
    }
    guard let firstName = fullName.firstName, let lastName = fullName.lastName else {
      print("First and Last names are required")
      return [:]
    }
    
    let signatureText = "\(deviceId)\(dob)\(fullName.firstName ?? "")\(gender)\(handle)\(lang)\(fullName.lastName ?? "")\(fullName.middleName ?? "")\(preferredName)\(timeStamp)\(type)\(userName)\(encryptedPassword)"
    let signatureKey = JARVISViewModelUtils.generateSignatureKey(with: decryptedFk)
    let signature = JARVISViewModelUtils.generateSignature(with: signatureKey, signatureText: signatureText)
    return [  registRequestParam.deviceId.rawValue      : deviceId,
              registRequestParam.handle.rawValue        : handle,
              registRequestParam.lang.rawValue          : lang,
              registRequestParam.firstName.rawValue     : firstName,
              registRequestParam.middleName.rawValue    : fullName.middleName ?? "",
              registRequestParam.lastName.rawValue      : lastName,
              registRequestParam.preferredName.rawValue : preferredName,
              registRequestParam.gender.rawValue        : gender,
              registRequestParam.dob.rawValue           : dob,
              registRequestParam.username.rawValue      : userName,
              registRequestParam.userPass.rawValue      : encryptedPassword,
              registRequestParam.timeStamp.rawValue     : timeStamp,
              registRequestParam.type.rawValue          : type,
              registRequestParam.signature.rawValue     : signature
    ]
  }
  
  var decryptedFk: [UInt8] {
    guard let bytesHandle = handle.base64StringToByteArray(), let bytesFk = fk.base64StringToByteArray(), let ikHexStringToBytes = challengeKey.hexStringToBytes() else { return [] }
    if let fk = JARVISViewModelUtils.decrypt(values: bytesFk, withKey: ikHexStringToBytes, withIv: bytesHandle) {
      return fk
    }
    return []
  }
  
  // MARK: - Initialize
  init(challengeKey: ChallengeViewModel, fk: String, deviceId: String, handle: String, lang: String, fullName: Name, preferredName: String, gender: String, dob: String, userName: String, userPass: String, type: Int, timeStamp: String) {
    self.challengeKey = challengeKey.decryptedIkHex64String
    self.fk = fk
    self.deviceId = deviceId
    self.handle = handle
    self.lang = lang
    self.fullName = fullName
    self.preferredName = preferredName
    self.gender = gender
    self.dob = dob
    self.userName = userName
    self.userPass = userPass
    self.type = type
    self.timeStamp = timeStamp.utcToDateString()
  }
}

// MARK: - JARVISViewModel.Register Private Members
private extension RegisterViewModel {
  var encryptedPassword: String? {
    guard let bytesHandle = handle.base64StringToByteArray() else { return "" }
    let fkHextStringToBytes = JARVISViewModelUtils.generateEnDecryptionKeys(with: decryptedFk)
    let userPassword = [UInt8](userPass.utf8)
    if let encryptedPass = JARVISViewModelUtils.encrypt(values: userPassword, withKey: fkHextStringToBytes, withIv: bytesHandle) {
      return encryptedPass
    }
    return nil
  }
}

struct Name {
  var firstName: String?
  var middleName: String?
  var lastName: String?
  
  init(fullName: String) {
    let fullNames = fullName.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
    switch fullNames.count {
    case 1:
      guard let firstName = fullNames.first else { return }
      self.firstName = String(firstName)
    case 2:
      guard let firstName = fullNames.first, let lastName = fullNames.last else { return }
      self.firstName = String(firstName)
      self.lastName = String(lastName)
    default:
      guard let firstName = fullNames.first, !fullNames[1].isEmpty, let lastName = fullNames.last else { return }
      self.firstName = String(firstName)
      self.middleName = String(fullNames[1])
      self.lastName = String(lastName)
    }
  }
}
