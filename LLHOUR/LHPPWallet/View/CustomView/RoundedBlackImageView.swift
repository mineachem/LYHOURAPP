//
//  RoundedBlackImageView.swift
//  LHPP Wallet
//
//  Created by User on 8/15/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class RoundedBlackImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
        self.clipsToBounds = true
    }
}
