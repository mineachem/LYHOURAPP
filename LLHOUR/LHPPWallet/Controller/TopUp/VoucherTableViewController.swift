//
//  VoucherTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/11/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard

enum TopUpAmountOption: Int {
  case oneDollar = 1
  case twoDollar = 2
  case fiveDollar = 5
  case tenDollar = 10
  case fifteenDollar = 15
  case tweentyDollar = 20
}

class VoucherTableViewController: UITableViewController {
  
  // MARK: - Properties
  @IBOutlet weak var voucherCollectionView: UICollectionView!
  
  var vouchImage = [UIImage(named: "smart"),
                    UIImage(named: "cellcard"),
                    UIImage(named: "metfone")]
  var voucherTitle = ["Smart", "Cellcard", "Metfone"]
  
  @IBOutlet weak var oneDollarButton: RoundButton!
  @IBOutlet weak var twoDollarButton: RoundButton!
  @IBOutlet weak var fiveDollarButton: RoundButton!
  @IBOutlet weak var tenDollarButton: RoundButton!
  @IBOutlet weak var fifteenDollarButton: RoundButton!
  @IBOutlet weak var tweentyDollarButton: RoundButton!
  
  var amountButtons = [RoundButton]()
  var selectedAmount = 0
  var selectedAmountButton: RoundButton!
  private var selectedNetwork = ""
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func amountButtonTapped(_ sender: RoundButton) {
    amountButtons = [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton, fifteenDollarButton, tweentyDollarButton]
    
    if sender.tag > amountButtons.count - 1 {
      return
    }
    
    selectedAmountButton = amountButtons.remove(at: sender.tag)
    selectedAmountButton.backgroundColor = .redRoundButton
    selectedAmountButton.setTitleColor(.white, for: .normal)
    selectedAmount = selectAmount(index: selectedAmountButton.tag)
    
    amountButtons.forEach { (button) in
      button.backgroundColor = .white
      button.setTitleColor(.darkGray, for: .normal)
    }
  }
  
  @IBAction func generate(_ sender: RoundButton) {
    if selectedNetwork.isEmpty {
      alertMessage(title: "Error", message: "Please select your network to top up.", on: self)
    } else if selectedAmount == 0 {
      alertMessage(title: "Error", message: "Please select amount to top up.", on: self)
    } else {
      guard let typeYourPINController = SwinjectStoryboard.initController(withIdentifier: ControllerName.transactionPINController.rawValue, fromStoryboard: StoryboardName.topup.rawValue) as? TransactionPINController else { return }
      typeYourPINController.selectedAmount = selectedAmount
      typeYourPINController.selectedNetwork = selectedNetwork
      navigationController?.pushViewController(typeYourPINController, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension VoucherTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return voucherTitle.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let networkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCollectionViewCell", for: indexPath) as? NetworkCollectionViewCell else { return UICollectionViewCell() }
    networkCell.logoImageView.image = vouchImage[indexPath.item]
    networkCell.titleLabel.text = voucherTitle[indexPath.item]
    return networkCell
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    if (collectionView.indexPathsForSelectedItems ?? []).contains(indexPath) {
      // Item is already selected, so deselect it.
      collectionView.deselectItem(at: indexPath, animated: false)
      return false
    } else {
      return true
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedNetwork = voucherTitle[indexPath.item]
  }
}

private extension VoucherTableViewController {
  func setupUI() {
    voucherCollectionView.delegate = self
    voucherCollectionView.dataSource = self
    
    amountButtons = [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton, fifteenDollarButton, tweentyDollarButton]
    selectedAmount = selectAmount(index: 0)
  }
  
  func selectAmount(index: Int) -> Int {
    switch index {
    case 0: return TopUpAmountOption.oneDollar.rawValue
    case 1: return TopUpAmountOption.twoDollar.rawValue
    case 2: return TopUpAmountOption.fiveDollar.rawValue
    case 3: return TopUpAmountOption.tenDollar.rawValue
    case 4: return TopUpAmountOption.fifteenDollar.rawValue
    case 5: return TopUpAmountOption.tweentyDollar.rawValue
    default: return 0
    }
  }
}
