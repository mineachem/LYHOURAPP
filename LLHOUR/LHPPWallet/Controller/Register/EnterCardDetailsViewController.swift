//
//  EnterCardDetailsViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/19/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class EnterCardDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       setupClearNavigation()
    }

    func setupClearNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
    }
    
    @IBAction func skipItemTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    }
    
}
