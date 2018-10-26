//
//  DropDownButton.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/4/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

class DropDownButton: UIButton {

  var dropView = TotalAmountDropDownView()
  var height = NSLayoutConstraint()
  var isOpen = false
  
  private var isInDismissingProcess = false
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .clear
    dropView = TotalAmountDropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    dropView.delegate = self
    dropView.translatesAutoresizingMaskIntoConstraints = false
    NotificationCenter.default.addObserver(self, selector: #selector(handleDismissing), name: NSNotification.Name(rawValue: "DismissSubmitController"), object: nil)
  }
  
  @objc func handleDismissing() {
    isInDismissingProcess = true
  }
  
  override func didMoveToSuperview() {
    if !isInDismissingProcess {
      superview?.addSubview(dropView)
      superview?.bringSubviewToFront(dropView)
      dropView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
      dropView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      dropView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
      height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isOpen == false {
      isOpen = true
      NSLayoutConstraint.deactivate([height])
      if dropView.tableView.contentSize.height > 150 {
        height.constant = 150
      } else {
        height.constant = dropView.tableView.contentSize.height
      }
      
      NSLayoutConstraint.activate([height])
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.dropView.layoutIfNeeded()
        self.dropView.center.y += self.dropView.frame.height / 2
      }, completion: nil)
      
    } else {
      isOpen = false
      NSLayoutConstraint.deactivate([height])
      height.constant = 0
      NSLayoutConstraint.activate([height])
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.dropView.center.y -= self.dropView.frame.height / 2
        self.dropView.layoutIfNeeded()
      }, completion: nil)
      
    }
  }
  
  func dismissDropDown() {
    isOpen = false
    NSLayoutConstraint.deactivate([self.height])
    self.height.constant = 0
    NSLayoutConstraint.activate([self.height])
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.dropView.center.y -= self.dropView.frame.height / 2
      self.dropView.layoutIfNeeded()
    }, completion: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension DropDownButton: DropDownProtocol {
  func dropDownPressed(string: String) {
    self.setTitle(string, for: .normal)
    self.dismissDropDown()
  }
}
