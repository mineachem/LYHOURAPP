//
//  TotalAmountCell.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/4/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

class TotalAmountCell: UITableViewCell {
  
  @IBOutlet weak var titleFeeLabel: UILabel!
  @IBOutlet weak var feeLabel: UILabel!
  
}

extension TotalAmountCell {
  static var identifier: String {
    return String(describing: TotalAmountCell.self)
  }
}
