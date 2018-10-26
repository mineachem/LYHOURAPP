//
//  OffersCollectionViewCell.swift
//  LHPP Wallet
//
//  Created by User on 8/9/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class OffersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgOfferImageView: UIImageView!
    @IBOutlet weak var bgDiscountImageView: UIImageView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var shadowbgView: UIView!
    
    override func awakeFromNib() {
        bgOfferImageView.layer.cornerRadius = 10
        bgDiscountImageView.layer.masksToBounds = true
        bgDiscountImageView.layer.cornerRadius = 10
        bgDiscountImageView.layer.masksToBounds = true
        
        shadowbgView.layer.cornerRadius = 10
        shadowbgView.layer.masksToBounds = true
    }
}
