//
//  SearchWalletTableViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class SearchWalletTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var iconFlagImageView: UIImageView!
    @IBOutlet weak var nameFagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
