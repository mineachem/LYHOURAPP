//
//  AddMoneyMenuCell.swift
//  LHPP Wallet
//
//  Created by User on 7/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
class AddMoneyMenuCell: UICollectionViewCell {
    @IBOutlet weak var menuAddMoney: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: menuAddMoney)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: menuAddMoney)
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: indicatorView)
        addConstraintsWithFormatString(formate: "V:[v0(3)]|", views: indicatorView)
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.30) {
                self.indicatorView.backgroundColor = self.isSelected ? UIColor.white : UIColor.clear
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuAddMoney.text = ""
    }
}
