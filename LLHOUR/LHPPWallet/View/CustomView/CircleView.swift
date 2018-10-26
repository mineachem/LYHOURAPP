//
//  CircleView.swift
//  IOS12DrawCirclesTutorial
//
//  Created by Arthur Knopper on 12/06/2018.
//  Copyright © 2018 Arthur Knopper. All rights reserved.
//

import UIKit

class CircleView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    // Get the Graphics Context
    if let context = UIGraphicsGetCurrentContext() {
      
      // Set the circle outerline-width
      context.setLineWidth(3)
      
      // Set the circle outerline-colour
      UIColor.blue.set()
      
      // Create Circle
      let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 - 15)
      let radius = frame.size.width / 3.4
      context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
      
      // Draw
      context.strokePath()
    }
  }
}
