//
//  TransfersTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/11/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class TransfersTableViewController: UITableViewController {
  
  @IBOutlet weak var transfersCollectionView: UICollectionView!
  
  var logoImage = [UIImage(named: "smart"), UIImage(named: "cellcard"), UIImage(named: "metfone")]
  var subIconImage = [UIImage(named: "flag_kh"), UIImage(named: "flag_of_thai"), UIImage(named: "us-flag")]
  var titleLogo = ["Self", "Self", "wifey"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    transfersCollectionView.dataSource = self
    transfersCollectionView.delegate = self
    
    tableView.estimatedSectionHeaderHeight = 0
    tableView.estimatedSectionFooterHeight = 0
    transfersCollectionView.reloadData()
    
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
  
}

extension TransfersTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return titleLogo.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let transferCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionCell", for: indexPath) as? RecentCollectionCell else { return UICollectionViewCell() }
    transferCollection.logoImageView.image = logoImage[indexPath.row]
    transferCollection.subIconImageView.image = subIconImage[indexPath.row]
    transferCollection.titleLogoLabel.text = titleLogo[indexPath.row]
    return transferCollection
  }
}
