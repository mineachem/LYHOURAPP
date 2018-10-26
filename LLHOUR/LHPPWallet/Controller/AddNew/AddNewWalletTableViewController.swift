//
//  AddNewWalletTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/13/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import Material
import Motion
import NVActivityIndicatorView

class AddNewWalletTableViewController: UITableViewController {
  
  // MARK: - Properties
  @IBOutlet weak var walletNameTextField: TextField!
  @IBOutlet weak var addNewCollectionView: UICollectionView!
  
  var transactionAPI: TransactionAPI!
  var authResponse: AuthResponse!
  
  private var logo = [#imageLiteral(resourceName: "us-flag"), #imageLiteral(resourceName: "flag_kh"), #imageLiteral(resourceName: "flag_of_thai")]
  private var titleLogo = ["USD", "KHR", "THB"]
  private var activityIndicatorView: NVActivityIndicatorView!
  
  // MARK: Override Members
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupCollectionView()
  }
  
  @IBAction func addWallet(_ sender: RoundButton) {
    guard let handle = UserDefaults.value(forKey: .handle) else { return }
    showActivityView(message: "Adding A New Wallet ...", messageColor: .white) { [weak self] in
      let addWalletModel = AddWalletViewModel(currency: "KHR", deviceId: UIDevice.deviceId, handle: handle, lang: "EN", timeStamp: Date.javisDateFormat)
      self?.transactionAPI.addWallet(parameters: addWalletModel.parameters) { (response, error) in
        if let err = error, let strongSelf = self {
          self?.stopAnimating(nil)
          alertMessage(title: "Error", message: err, on: strongSelf)
          return
        }
        
        guard let addWalletResponse = response else { return }
        print(addWalletResponse.info ?? "")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNewWalletNotification"), object: nil)
        self?.stopAnimating(nil)
        let alertController = UIAlertController(title: "Success", message: "New Wallet has been added. Please view it in your home screen.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self?.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

extension AddNewWalletTableViewController: NVActivityIndicatorViewable {
  func showActivityView(message: String,
                        messageColor: UIColor,
                        minimumDisplayTime: Int? = nil,
                        completion: @escaping () -> Void) {
    let size = UIDevice.isPhone5SE ? CGSize(width: 40, height: 40) : CGSize(width: 60, height: 60)
    let backgroundColor = UIColor.black.withAlphaComponent(0.4)
    let fontSize: CGFloat = UIDevice.isPhone5SE ? 15 : 17
    let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    let displayTime = minimumDisplayTime ?? 1
    startAnimating(size, message: message, messageFont: font, type: .ballClipRotatePulse, minimumDisplayTime: displayTime, backgroundColor: backgroundColor, textColor: .white) { (_) in
      completion()
    }
  }
}

// MARK: - Private Member
private extension AddNewWalletTableViewController {
  func setupUI() {
    walletNameTextField.placeholderNormalColor = .gray
    walletNameTextField.placeholderActiveColor = .gray
    
    walletNameTextField.dividerNormalColor = .lightGray
    walletNameTextField.dividerActiveColor = .lightGray
    
    setupActivityIndicatorView()
  }
  
  func setupActivityIndicatorView() {
    let rect = CGRect(center: view.center, size: CGSize(width: 60, height: 60))
    activityIndicatorView = NVActivityIndicatorView(frame: rect, type: .ballClipRotatePulse)
    view.addSubview(activityIndicatorView)
  }
  
  func setupCollectionView() {
    addNewCollectionView.delegate = self
    addNewCollectionView.dataSource = self
    addNewCollectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension AddNewWalletTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return titleLogo.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletCollectionCell", for: indexPath) as? ContentWalletCollectionViewCell else { return UICollectionViewCell() }
    collectionCell.logoImageView.image = logo[indexPath.row]
    collectionCell.titleLabel.text = titleLogo[indexPath.row]
    return collectionCell
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
}
