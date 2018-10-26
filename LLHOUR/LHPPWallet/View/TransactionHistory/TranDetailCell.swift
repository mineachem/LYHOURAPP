//
//  TranDetailCell.swift
//  LHPP Wallet
//
//  Created by User on 8/6/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

struct TranDetailItem {
  var priceAmountString: String
  var priceDiscountString: String
  var dateTimeString: String
  var addressString: String
  
  init(priceAmountString: String, priceDiscountString: String, dateTimeString: String, addressString: String) {
    self.priceAmountString = priceAmountString
    self.priceDiscountString = priceDiscountString
    self.dateTimeString = dateTimeString
    self.addressString = addressString
  }
}

class TranDetailCell: UITableViewCell {
  @IBOutlet weak var priceAmountLabel: UILabel!
  @IBOutlet weak var priceDiscountLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
