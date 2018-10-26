//
//  ContentVerifyViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/18/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import MXSegmentedPager

class ContentVerifyPagerViewController: MXSegmentedPagerController {
  
  @IBOutlet var headerView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    configContentPager()
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func configContentPager() {
    if #available(iOS 11.0, *) {
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
    return ["Card", "Manual"][index]
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}
