//
//  ManualTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/10/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
class ManualTableViewController: UITableViewController {
  
  @IBOutlet weak var documentCollectionView: UICollectionView!
  @IBOutlet weak var segmentControlPage: UISegmentedControl!
  
  let documentImage = [UIImage(named: "ic-photoid"), UIImage(named: "ic-selfie"), UIImage(named: "ic-more")]
  //     @IBOutlet weak var segmentControlPage: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSegment()
    documentCollectionView.delegate = self
    documentCollectionView.dataSource = self
    
    documentCollectionView.reloadData()
  }
  
  func setupSegment() {
    segmentControlPage.backgroundColor = .clear
    segmentControlPage.tintColor = .clear
    segmentControlPage.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 16)!, NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
    segmentControlPage.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
    
    segmentControlPage.selectedSegmentIndex = 0
    
    segmentControlPage.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
  }
  
  @IBAction func nextTapped(_ sender: UIButton) {
  }
  
  //segment for show 3 menu
  @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    UIView.animate(withDuration: 0.3) {
      
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

extension ManualTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return documentImage.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let documentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCollectionCell", for: indexPath) as? DocumentCollectionViewCell else { return UICollectionViewCell() }
    documentCell.documentImageVIew.image = documentImage[indexPath.row]
    
    return documentCell
    
  }
}
