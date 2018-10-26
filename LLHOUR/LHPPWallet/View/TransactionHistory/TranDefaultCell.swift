//
//  TranDefaultCell.swift
//  LHPP Wallet
//
//  Created by User on 8/23/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

struct TranDefaultItem {
  var expand: String?
  var iconImage: UIImage
  var titleTranString: String
  var subTitleTranString: String
  var priceTranString: String
  var tranDetail: TranDetailItem
}

class TranDefaultCell: UITableViewCell {
  @IBOutlet weak var iconTranImageView: UIImageView!
  @IBOutlet weak var titleTranLabel: UILabel!
  @IBOutlet weak var subTitleTranLabel: UILabel!
  @IBOutlet weak var priceTranLabel: UILabel!
}
