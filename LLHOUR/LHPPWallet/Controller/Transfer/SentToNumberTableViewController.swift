//
//  SentToNumberTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/12/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
class SentToNumberTableViewController: UITableViewController {
  
  @IBOutlet weak var contextTextField: TextField!
  @IBOutlet weak var nickNameTextField: TextField!
  @IBOutlet weak var sentToNumCollectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sentToNumCollectionView.delegate = self
    sentToNumCollectionView.dataSource = self
    
    setupTextField()
    
    setupClearNavigation()
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  func setupTextField() {
    contextTextField.dividerNormalColor = .clear
    contextTextField.dividerActiveColor = .clear
    
    contextTextField.placeholderNormalColor = .gray
    contextTextField.placeholderActiveColor = .gray
    
    nickNameTextField.placeholderNormalColor = .gray
    nickNameTextField.placeholderActiveColor = .gray
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true)
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SentToNumberTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let sentToNumCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentToNumberCollectionViewCell", for: indexPath) as? SentToNumberCollectionViewCell else { return UICollectionViewCell() }
    return sentToNumCollectionCell
  }
}
