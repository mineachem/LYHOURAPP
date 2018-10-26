//
//  PreperancesViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/8/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
  @IBOutlet weak var preferanceTableView: UITableView!
  @IBOutlet weak var bgPreperanceView: UIView!
  
  var header = ["Preference"]
  var iconImage = [#imageLiteral(resourceName: "ic-lock-black"), #imageLiteral(resourceName: "ic-user-lock"), #imageLiteral(resourceName: "ic-pattern"), #imageLiteral(resourceName: "ic-email-message")]
  var titleString = ["Setup PIN", "Use Login PIN", "Setup Pattern", "Send SMS"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferanceTableView.dataSource = self
    preferanceTableView.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension PreferencesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return header.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleString.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let preparenceCell = tableView.dequeueReusableCell(withIdentifier: "PreferanceCell", for: indexPath) as? PreferanceCell else { return UITableViewCell() }
    
    preparenceCell.iconImageView.image = iconImage[indexPath.row]
    preparenceCell.titleLabel.text = titleString[indexPath.row]
    
    if indexPath.row == 3 {
      preparenceCell.subTitleLabel.alpha = 1
    }
    return preparenceCell
  }
}

// MARK: - UITableViewDelegate
extension PreferencesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let bgView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    let label = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width, height: 20))
    label.text = header[section]
    label.textColor = UIColor.red
    bgView.addSubview(label)
    return bgView
    
  }
}
