//
//  AddSelectionViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/1/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class AddSelectionViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var addSelectionTableView: UITableView!
  @IBOutlet weak var addButton: RoundButton!
  @IBOutlet weak var callingButton: RoundButton!
  @IBOutlet weak var creditButton: RoundButton!
  @IBOutlet weak var walletButton: RoundButton!
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  private let sectionAddSelect = ["Self", "Friend", "Lyhour Card", "Mobile Number"]
  private var callingButtonCenter: CGPoint!
  private var creditButtonCenter: CGPoint!
  private var walletButtonCenter: CGPoint!
  
  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    floatButton()
    clearBgNavBar()
  }
  
  // MARK: - Action Members
  @IBAction func addOtherViewTapped(_ sender: RoundButton) {
    toggleButton(button: sender, onImage: UIImage(named: "cancel")!, offImage: UIImage(named: "plus")!)
    if addButton.currentImage ==  UIImage(named: "cancel")! {
      //expand buttons
      
      UIView.animate(withDuration: 0.3) {
        self.callingButton.alpha = 1
        self.creditButton.alpha = 1
        self.walletButton.alpha = 1
        //animations here!
        self.callingButton.center = self.callingButtonCenter
        self.creditButton.center = self.creditButtonCenter
        self.walletButton.center = self.walletButtonCenter
      }
    } else {
      // collapse buttons
      UIView.animate(withDuration: 0.3) {
        self.callingButton.alpha = 0
        self.creditButton.alpha = 0
        self.walletButton.alpha = 0
        //animations here!
        self.callingButton.center = self.addButton.center
        self.creditButton.center = self.addButton.center
        self.walletButton.center = self.addButton.center
      }
    }
  }
  
  @IBAction func callingVCTapped(_ sender: RoundButton) {
    toggleButton(button: sender, onImage: UIImage(named: "call-answer")!, offImage: UIImage(named: "call-answer")!)
    
    performSegue(withIdentifier: "callingIdentifier", sender: self)
  }
  
  @IBAction func creditVCTapped(_ sender: RoundButton) {
    toggleButton(button: sender, onImage: UIImage(named: "credit-card-back")!, offImage: UIImage(named: "credit-card-back")!)
    performSegue(withIdentifier: "sentTocardIdentifier", sender: self)
  }
  
  @IBAction func walletVCTapped(_ sender: RoundButton) {
    toggleButton(button: sender, onImage: UIImage(named: "wallet-white")!, offImage: UIImage(named: "wallet-white")!)
    
    performSegue(withIdentifier: "sentToWalletIdentifier", sender: self)
  }
}

// MARK: - Private Members
private extension AddSelectionViewController {
  func setupTableView() {
    addSelectionTableView.delegate = self
    addSelectionTableView.dataSource = self
  }
  
  func clearBgNavBar() {
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
  }
  
  func floatButton() {
    callingButtonCenter = callingButton.center
    creditButtonCenter = creditButton.center
    walletButtonCenter = walletButton.center
    
    callingButton.center = addButton.center
    creditButton.center = addButton.center
    walletButton.center = addButton.center
  }
  
  func toggleButton(button: UIButton, onImage:UIImage, offImage:UIImage) {
    if button.currentImage == offImage {
      button.setImage(onImage, for:.normal)
    } else {
      button.setImage(offImage, for: .normal)
    }
  }
}

// MARK: - UITableViewDataSource
extension AddSelectionViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionAddSelect.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let addSelectTransCell = tableView.dequeueReusableCell(withIdentifier: "AddSelectTableViewCell", for: indexPath) as? AddSelectTableViewCell else { return UITableViewCell() }
    
    return addSelectTransCell
  }
}

// MARK: - UITableViewDelegate
extension AddSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "HeaderSelectTableViewCell") as? HeaderSelectTableViewCell else { return UIView() }
    sectionHeader.titleHeaderTranLabel.text = sectionAddSelect[section]
    return sectionHeader
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableCell(withIdentifier: "FooterTransferTableViewCell") as? FooterTransferTableViewCell else { return UIView() }
    return footer
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}
