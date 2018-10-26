//
//  SentToCardViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/12/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class SentToCardViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var sentToCardTableView: UITableView!
  
  let sectionHeaderSentTocard = ["Account"]
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupClearNavigation()
  }
  
  // MARK: - Action Members
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true)
  }
}

private extension SentToCardViewController {
  func setupTableView() {
    sentToCardTableView.delegate = self
    sentToCardTableView.dataSource = self
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
}

// MARK: - UITableViewDataSource
extension SentToCardViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionHeaderSentTocard.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerSentTocard = tableView.dequeueReusableCell(withIdentifier: "HeaderSentToCardTableViewCell") as? HeaderSentToCardTableViewCell else { return UIView() }
    headerSentTocard.titleHeaderSentTocardLabel.text = sectionHeaderSentTocard[section]
    return headerSentTocard
  }
}

// MARK: - UITableViewDelegate
extension SentToCardViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let sentTocardCell = tableView.dequeueReusableCell(withIdentifier: "SentToCardTableViewCell", for: indexPath) as? SentToCardTableViewCell else { return UITableViewCell() }
    
    return sentTocardCell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}
