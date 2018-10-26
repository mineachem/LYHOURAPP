//
//  PreperanceCell.swift
//  LHPP Wallet
//
//  Created by User on 8/8/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class PreferanceCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
