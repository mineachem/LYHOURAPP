//
//  UIView+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 9/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

private var lineConstraints = [NSLayoutConstraint]()

extension UIView {
  
  enum LinePosition {
    case top
    case bottom
  }
  
  func addLine(to position: LinePosition, color: UIColor, width: Double) {
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
    self.addSubview(lineView)
    
    let metrics = ["width" : NSNumber(value: width)]
    let views = ["lineView" : lineView]
    self.addConstraints(constraints(format: "H:|[lineView]|", metrics: metrics, views: views))
    
    switch position {
    case .top:
      self.addConstraints(constraints(format: "V:|[lineView(width)]", metrics: metrics, views: views))
    case .bottom:
      self.addConstraints(constraints(format: "V:[lineView(width)]|", metrics: metrics, views: views))
    }
  }
  
  func removeLineConstraints() {
    self.removeConstraints(lineConstraints)
  }
  
  func addConstraintsWithFormatString(formate: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
  }
}

private extension UIView {
  private func constraints(format: String, metrics: [String : NSNumber], views: [String : UIView]) -> [NSLayoutConstraint] {
    lineConstraints = NSLayoutConstraint.constraints(withVisualFormat: format, options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views)
    return lineConstraints
  }
}
