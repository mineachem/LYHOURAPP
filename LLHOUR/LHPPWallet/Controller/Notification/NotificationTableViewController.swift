//
//  NotificationTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
  
  let logo = [#imageLiteral(resourceName: "flag_of_thai"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "us-flag")]
  let titleNotification = ["dldldldd", "dkdkdkdk", "dldldldl"]
  let desc = ["dldlldllllllllll", "dllllllllllll", "dldldddddddddddd"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    clearSeperatorFooter()
    setupClearNavigation()
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
  
  func clearSeperatorFooter() {
    let footerEmpty = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.bounds.height/2))
    footerEmpty.backgroundColor = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    tableView.tableFooterView = footerEmpty
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleNotification.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let notificationCell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell else { return UITableViewCell() }
    notificationCell.logoImageView.image = logo[indexPath.row]
    notificationCell.descriptionLabel.text = desc[indexPath.row]
    notificationCell.titleLabel.text = titleNotification[indexPath.row]
    
    return notificationCell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}
