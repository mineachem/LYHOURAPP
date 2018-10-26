//
//  RoundImagesCustom.swift
//  LHPP Wallet
//
//  Created by User on 7/14/18.
//  Copyright © 2018 IG. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class RoundedImageView: UIImageView {
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
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    
        self.clipsToBounds = true
    }
}
