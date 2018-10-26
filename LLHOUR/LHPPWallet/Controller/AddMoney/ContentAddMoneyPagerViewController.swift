//
//  AddMoneyViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import MXSegmentedPager

class ContentAddMoneyPagerViewController: MXSegmentedPagerController {
  
  // MARK: - Properties
  @IBOutlet var headerView: UIView!
  var transactionAPI: TransactionAPI!
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    configContentPager()
    setupClearNavigation()
  }
  
  @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
    return ["9-digit", "Agent"][index]
  }
}

// MARK: - Private Members
private extension ContentAddMoneyPagerViewController {
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
}
