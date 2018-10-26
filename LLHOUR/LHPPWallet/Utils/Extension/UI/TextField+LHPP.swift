//
//  TextField+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/23/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Material

extension TextField {
  
  /**
   Check if Username has valid format.
   - User is allowed to enter texts only, or texts with numbers and it should have at least 5 characters long.
   - User is not allowed to enter any special characters, or whitespaces, and it should not have less than 5 characters long or more than 30 characters long.
   
   - Returns: **true** if the conditions are met or **false** if the conditions are not met
   */
  func isUserNameValid() -> Bool {
    let regEx = "\\w{5,30}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
    return predicate.evaluate(with: self.text, substitutionVariables: nil)
  }
  
  /**
   Check if Password has valid format.
   - User is allowed to enter at leaset 1 uppercase and 1 lowercase and 1 number and 1 special character. It should contain at least 8 character
   
   - Returns: **true** if the conditions are met or **false** if the conditions are not met
   */
  func isPasswordValid() -> Bool {
    let regEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
    return predicate.evaluate(with: self.text, substitutionVariables: nil)
  }
}
