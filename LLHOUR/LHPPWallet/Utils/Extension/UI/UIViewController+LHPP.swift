//
//  UIViewController+LHPP.swift
//  LHPP Wallet
//
//  Created by Visal Va on 8/23/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

func alertMessage(title: String, message: String, on controller: UIViewController, completion: ((UIAlertAction) -> Void)? = nil) {
  let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
  let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
    completion?(action)
  })
  alertController.addAction(okAction)
  if controller.presentedViewController != nil {
    controller.presentedViewController?.present(alertController, animated: true, completion: nil)
  } else {
    controller.present(alertController, animated: true, completion: nil)
  }
}
