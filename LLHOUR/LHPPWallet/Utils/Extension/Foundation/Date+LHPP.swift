//
//  Date+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

extension Date {
  static var javisDateFormat: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm:ss"
    return dateFormatter.string(from: Date())
  }
}
