//
//  QuickPayViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/1/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit

class CardQuickPayPopUpViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var discountLabel: UILabel!
  @IBOutlet weak var pricesLabel: UILabel!
  @IBOutlet weak var pricesDiscountLabel: UILabel!
  @IBOutlet weak var pricesMerchantLabel: UILabel!
  @IBOutlet weak var totalAmountLabel: UILabel!
  
  var iconImageView  = [ #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_of_thai"), #imageLiteral(resourceName: "us-flag") ]
  var priceString    = [ "$120.0", "$200.0", "$250.0", "$150.0", "$180.0" ]
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  
  // MARK: - Override Member
  override func viewDidLoad() {
    super.viewDidLoad()
    cardCollectionView.delegate = self
    cardCollectionView.dataSource = self
  }
  
  // MARK: - Action Member
  @IBAction func payButtonTapped(_ sender: RoundButton) {
    
  }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension CardQuickPayPopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return priceString.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricesCardCell", for: indexPath) as? PricesCardCollectionCell else { return UICollectionViewCell() }
    cardCell.iconFlagImageView.image = iconImageView[indexPath.row]
    cardCell.priceLabel.text = priceString[indexPath.row]
    
    return cardCell
  }
}
