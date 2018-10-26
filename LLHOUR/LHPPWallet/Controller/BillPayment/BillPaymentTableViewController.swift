//
//  BillPaymentTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/13/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
class BillPaymentTableViewController: UITableViewController {
  
  // MARK: - Properties
  @IBOutlet weak var cashInButton: RoundButton!
  @IBOutlet weak var billNumTextField: TextField!
  @IBOutlet weak var amountTextField: TextField!
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
  
    clearDividerTextField()
    setupClearNavigation()
  }
  
  // MARK: - Action Members
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    
  }
  
  @IBAction func cashInTapped(_ sender: RoundButton) {
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 140
    } else if indexPath.row == 1 {
      return 90
    } else {
      return UITableView.automaticDimension
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

private extension BillPaymentTableViewController {
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func clearDividerTextField() {
    billNumTextField.dividerNormalColor = .clear
    billNumTextField.dividerActiveColor = .clear
    billNumTextField.placeholderNormalColor = .gray
    billNumTextField.placeholderActiveColor = .gray
    
    amountTextField.dividerNormalColor = .clear
    amountTextField.dividerActiveColor = .clear
    amountTextField.placeholderNormalColor = .gray
    amountTextField.placeholderActiveColor = .gray
  }
}
