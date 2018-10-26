//
//  SubmitController.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/4/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

class SubmitController: UIViewController {
  
  @IBOutlet weak var closeImageView: UIImageView!
  @IBOutlet weak var totalFeesView: CustomUIView!
  @IBOutlet weak var totalDiscountView: CustomUIView!
  
  var totalFeeButton = DropDownButton()
  var totalDiscountButton = DropDownButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    navigationController?.navigationBar.isHidden = false
  }
  
  func setupUI() {
    totalFeeButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    totalDiscountButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    setupDropDownButton(with: totalFeeButton, onParentView: totalFeesView, options: ["Transaction Fee", "SMS Fee", "Forex Fee"], detailOptipons: ["$ 15.0", "$ 22.9", "$ 99.99"])
    setupDropDownButton(with: totalDiscountButton, onParentView: totalDiscountView, options: ["Transaction Fee", "SMS Fee", "Forex Fee"], detailOptipons: ["$ 15.0", "$ 22.9", "$ 99.99"])
    closeImageView.isUserInteractionEnabled = true
    closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissed)))
    navigationController?.navigationBar.isHidden = true
  }
  
  func setupDropDownButton(with button: DropDownButton, onParentView view: UIView, options: [String], detailOptipons: [String]) {
    button.setImage(UIImage(named: "expand-arrow-50"), for: .normal)
    button.contentHorizontalAlignment = .right
    button.imageView?.contentMode = .scaleAspectFit
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
    button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    button.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    button.dropView.dropDownOptions = options
    button.dropView.detailsDropDownOptions = detailOptipons
  }
  
  @objc func dismissed() {
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    transition.type = .reveal
    transition.subtype = .fromBottom
    navigationController?.view.layer.add(transition, forKey:kCATransition)
    navigationController?.popViewController(animated: false)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissSubmitController"), object: nil)
  }
}
