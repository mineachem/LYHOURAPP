//
//  ManageRecipientsTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/16/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class ManageRecipientsTableViewController: UITableViewController {
  
  // MARK: - Properties
  let sections      = [ "Self", "Friends",
                        "Ly Hour Cards",
                        "Mobile Numbers"
  ]
  
  let itemName      = [ [ "Adolf Dsilva",
                          "Adolf Dsilva",
                          "Adolf Dsilva"
                        ], //self
                        [ "Chea Sokha",
                          "Chea Sokha",
                          "Glenn", "Sagar"
                        ], // friend
                        [ "Wifey",
                          "John Doe"
                        ], // LyHour Cards
                        [ "Chea Sokha" ] //Mobile Number
  ]
  
  let profileImage = [ [ #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo") ],
                        [ #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo") ],
                        [ #imageLiteral(resourceName: "tousles_jourslogo"), #imageLiteral(resourceName: "tousles_jourslogo")],
                        [ #imageLiteral(resourceName: "tousles_jourslogo") ] ]
  
  let flagImage    = [ [ #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "us-flag"), #imageLiteral(resourceName: "flag_of_thai") ],
                        [ #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "us-flag"), #imageLiteral(resourceName: "flag_of_thai"), #imageLiteral(resourceName: "flag_kh") ],
                        [ #imageLiteral(resourceName: "us-flag"), #imageLiteral(resourceName: "flag_of_thai") ],
                        [ #imageLiteral(resourceName: "flag_kh") ]
  ]
  
  let itemPrice     = [ [ "126,000", "840,000", "840,000" ],
                        [ "840,000", "840,000", "840,000", "840,000" ],
                        [ "840,000", "840,000" ],
                        [ "840,000" ]
  ]
  
  let nameFlag      = [ [ "KHR", "USD", "THB" ],
                        [ "KHR", "USD", "USD", "KHR" ],
                        [ "KHR", "USD" ],
                        [ "USD" ]
  ]
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    setupClearNavigation()
    navigationItem.title = "Manage Recipients"
  }
  
  // MARK: - Action Members
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemName[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "mangerRecipientscell", for: indexPath) as? ManageRecipientsCell else { return UITableViewCell() }
    cell.profileImage.image = profileImage[indexPath.section][indexPath.row]
    cell.flagImage.image = flagImage[indexPath.section][indexPath.row]
    cell.nameFlagLabel.text = nameFlag[indexPath.section][indexPath.row]
    cell.nameFlagLabel.numberOfLines = 0
    cell.pricesLabel.text = itemPrice[indexPath.section][indexPath.row]
    cell.pricesLabel.numberOfLines = 0
    cell.usernameLabel.text = itemName[indexPath.section][indexPath.row]
    cell.usernameLabel.numberOfLines = 0
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerManager = tableView.dequeueReusableCell(withIdentifier: "HeaderManageCell") as? HeaderManageRecipitentCell else { return UIView() }
    headerManager.titleHeaderLabel.text = sections[section]
    return headerManager
  }
  
  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableCell(withIdentifier: "FooterTransferTableViewCell") as? FooterTransferTableViewCell else { return UIView() }
    return footer
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 47
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 25
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}

// MARK: - Private Members
private extension ManageRecipientsTableViewController {
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
}
