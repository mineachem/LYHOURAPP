//
//  SentToWalletViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/13/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class SentToWalletViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var searchTableView: UITableView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  private let sectionAddSelect = ["Self", "Friend", "Lyhour Card", "Mobile Number"]
  
  private var logoImageView = [#imageLiteral(resourceName: "ic_topup"), #imageLiteral(resourceName: "ic_topup"), #imageLiteral(resourceName: "ic_topup"), #imageLiteral(resourceName: "ic_topup")]
  private var nameString = ["minea", "tony", "raing sey", "pheak"]
  private var phoneString = ["012 3333", "012 3333", "012 3333", "012 3333"]
  private var flag = [#imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_kh")]
  private var nameFlagString = ["USD", "KHR", "USD", "KHR"]
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    clearBgNav()
  }
  
  // MARK: - Action Members
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true)
  }
}

// MARK: - Private Members
private extension SentToWalletViewController {
  func setupTableView() {
    searchTableView.delegate = self
    searchTableView.dataSource = self
    searchTableView.estimatedRowHeight = 70
    searchTableView.estimatedSectionHeaderHeight = 60
    searchTableView.rowHeight = UITableView.automaticDimension
  }
  
  func clearBgNav() {
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
  }
}

// MARK: - UITableViewDataSource
extension SentToWalletViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionAddSelect.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let walletCell = tableView.dequeueReusableCell(withIdentifier: "SearchWalletTableViewCell", for: indexPath) as? SearchWalletTableViewCell else { return UITableViewCell() }
    return walletCell
  }
}

// MARK: - UITableViewDelegate
extension SentToWalletViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "HeaderSearchWalletCell") as? HeaderSearchWalletCell else { return UIView() }
    sectionHeader.titleHeaderLabel.text = sectionAddSelect[section]
    return sectionHeader
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}
