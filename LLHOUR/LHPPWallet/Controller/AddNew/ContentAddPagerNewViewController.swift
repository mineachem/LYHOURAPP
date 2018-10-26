//
//  ContentAddNewViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import MXSegmentedPager
import SwinjectStoryboard

class ContentAddPagerNewViewController: MXSegmentedPagerController {
  
  @IBOutlet var headerView: UIView!
  
  var transactionAPI: TransactionAPI!
  var authResponse: AuthResponse!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configContentPager()
    setupClearNavigation()
    navigationItem.title = "Add New"
    
    if authResponse != nil {
      if let handle = authResponse.handle {
        UserDefaults.set(value: handle, forKey: .handle)
      }
    }
  }
  
  @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func configContentPager() {
    if #available(iOS 11.0, *) {
      print("don't add header")
    } else {
      //Parallax Header
      segmentedPager.parallaxHeader.view = headerView
      segmentedPager.parallaxHeader.mode = .fill
      segmentedPager.parallaxHeader.height = 63
      
    }
    segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
    segmentedPager.segmentedControl.selectionIndicatorHeight = 2
    segmentedPager.segmentedControl.selectionIndicatorColor = .white
    segmentedPager.segmentedControl.selectionIndicatorLocation = .down
    segmentedPager.segmentedControl.backgroundColor = UIColor.colorFromHex("2667A4")
    segmentedPager.segmentedControl.titleTextAttributes = [kCTForegroundColorAttributeName : UIColor(displayP3Red: 142/255, green: 174/255, blue: 204/255, alpha: 1)]
    segmentedPager.segmentedControl.selectedTitleTextAttributes = [kCTForegroundColorAttributeName : UIColor.white]
  }
  
  override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
    return ["Wallet", "Card"][index]
  }
}
