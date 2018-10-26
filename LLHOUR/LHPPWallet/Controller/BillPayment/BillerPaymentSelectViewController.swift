//
//  BillerPaymentViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/24/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class BillerPaymentSelectViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var billPayTableView: UITableView!
  @IBOutlet weak var menuBillerCollectionView: UICollectionView!
  
  var isSizeToFitCellsNeeded: Bool = false {
    didSet {
      self.menuBillerCollectionView.reloadData()
    }
  }
  var menuBillerTitle = [ "Utilites",
                          "Finance",
                          "Insurance",
                          "Others"
  ]
  
  var logoImages      = [ UIImage(named: "smart"),
                          UIImage(named: "cellcard"),
                          UIImage(named: "metfone")
  ]
  
  var titleLogo       = [ "PPWSA",
                          "PPWSA",
                          "PPWSA"
  ]
  
  var subTileLogo     = [ "Phnom Penh",
                          "Phnom Penh",
                          "Phnom Penh"
  ]
  
  var iconFlag        = [ UIImage(named: "smart"),
                          UIImage(named: "cellcard"),
                          UIImage(named: "metfone")
  ]
  
  var titleFlag       = [ "kh",
                          "eng",
                          "thai"
  ]
  
  // MARK: - Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    billPayTableView.delegate = self
    billPayTableView.dataSource = self
    billPayTableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension BillerPaymentSelectViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleLogo.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let selectBillCell = tableView.dequeueReusableCell(withIdentifier: "SelectBillPaymentTableViewCell", for: indexPath) as? SelectBillPaymentTableViewCell else { return UITableViewCell() }
    selectBillCell.logoImageView.image = logoImages[indexPath.row]
    selectBillCell.titleBillPayLabel.text = titleLogo[indexPath.row]
    selectBillCell.subTitleBillPayLabel.text = subTileLogo[indexPath.row]
    selectBillCell.iconFlagImageView.image = iconFlag[indexPath.row]
    selectBillCell.titleFlagLabel.text = titleFlag[indexPath.row]
    
    return selectBillCell
  }
}

extension BillerPaymentSelectViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}
