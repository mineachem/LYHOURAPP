//
//  TranSactionDetailViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/29/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
struct HeaderItems {
  var name: String
  var expendable: String?
  var tranDefault: [TranDefaultItem]
  
  init(name: String, expendable: String, tranDefault: [TranDefaultItem]) {
    self.name = name
    self.expendable = expendable
    self.tranDefault = tranDefault
  }
}

class TranSactionDetailViewController: UIViewController {
  
  // MARK: Properties
  @IBOutlet weak var tranTableView: UITableView!
  @IBOutlet weak var tranSlideShowCollectionView: UICollectionView!
  @IBOutlet weak var pagesControl: UIPageControl!
  
  var dolar = ["$100.45", "$200.0", "$300.39", "$300.34"]
  var datasource: [HeaderItems]?
  // Mounted up number for auto scrolling
  lazy var x = 1
  // Time Intervale for auto scrolling
  let timeInterval:Double = 3.0
  var thereIsCellTapped = false
  var selectedRowIndex = -1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupColletionView()
    setTimer()
    setData()
    setupClearNavigation()
    
    pagesControl.numberOfPages = dolar.count
    pagesControl.currentPage = 0
  }
  
  func setupTableView() {
    tranTableView.delegate = self
    tranTableView.dataSource = self
  }
  
  func setupColletionView() {
    tranSlideShowCollectionView.delegate = self
    tranSlideShowCollectionView.dataSource = self
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
  
  private func setData() {
    // TranDetail data
    let tranDetailItem1 = TranDetailItem(priceAmountString: "$50.0", priceDiscountString: "-40.0", dateTimeString: "7,June 2017", addressString: "Phnom Penh")
    let tranDetailItem2 = TranDetailItem(priceAmountString: "$40.0", priceDiscountString: "-30.0", dateTimeString: "8,June, 2017", addressString: "Takeo")
    let tranDetailItem3 = TranDetailItem(priceAmountString: "$40.0", priceDiscountString: "-30.0", dateTimeString: "8,June, 2017", addressString: "Takeo")
    
    // TrandDefault data
    
    let tranDefault1 = [
      TranDefaultItem(expand: nil, iconImage: UIImage(named: "ic-transfer")!, titleTranString: "Mobile Up", subTitleTranString: "010 69 01 64", priceTranString: "-5.00", tranDetail: tranDetailItem1),
      TranDefaultItem(expand: nil, iconImage: UIImage(named: "ic-transfer")!, titleTranString: "Transfer", subTitleTranString: "010 69 01 64", priceTranString: "-5.00", tranDetail: tranDetailItem2)
    ]
    
    let tranDefault2 = [
      TranDefaultItem(expand: nil, iconImage: UIImage(named: "ic-transfer")!, titleTranString: "Mobile Up", subTitleTranString: "010 69 01 64", priceTranString: "-5.00", tranDetail: tranDetailItem1)
    ]
    
    let tranDefault3 = [
      TranDefaultItem(expand: nil, iconImage: UIImage(named: "ic-transfer")!, titleTranString: "Mobile Up", subTitleTranString: "010 69 01 64", priceTranString: "-5.00", tranDetail: tranDetailItem1),
      TranDefaultItem(expand: nil, iconImage: UIImage(named: "ic-transfer")!, titleTranString: "Transfer", subTitleTranString: "010 69 01 64", priceTranString: "-5.00", tranDetail: tranDetailItem3)
    ]
    
    // Header Section
    datasource = [
      HeaderItems(name: "Today", expendable: "", tranDefault: tranDefault1),
      HeaderItems(name: "Tomorrow", expendable:"", tranDefault: tranDefault2),
      HeaderItems(name: "Yesterday", expendable: "", tranDefault: tranDefault3)
    ]
  }
  
  // Scroll Automatically
  func setTimer() {
    if dolar.count > 0 {
      _ = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
  }
  
  // AutoScroll
  @objc func autoScroll() {
    if self.x < self.dolar.count {
      let indexPath = IndexPath(item: x, section: 0)
      //collection View: - Scroll Collection View
      self.tranSlideShowCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      //Page Control: -Scroll Page Control
      self.pagesControl.currentPage = indexPath.row
      self.x += 1
    } else {
      self.x = 0
      let indexPath = IndexPath(item: 0, section: 0)
      self.tranSlideShowCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
      self.pagesControl.currentPage = indexPath.row
    }
  }
  
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension TranSactionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dolar.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let slideCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideTransactionCollectionViewCell", for: indexPath) as? SlideTransactionCollectionViewCell else { return UICollectionViewCell() } 
    slideCollectionCell.pricesLabel.text = dolar[indexPath.item]
    return slideCollectionCell
  }
  
  // Scroll Mannually
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    var visibleRect = CGRect()
    
    visibleRect.origin = tranSlideShowCollectionView.contentOffset
    visibleRect.size = tranSlideShowCollectionView.bounds.size
    
    //visible point
    let visiblePoint = CGPoint(x: visibleRect.maxX, y: visibleRect.maxY)
    
    //current visible cell index path
    guard let indexPath = tranSlideShowCollectionView.indexPathForItem(at: visiblePoint) else { return }
    
    // When the cell is in current index, it will start from the next index for auto scrolling.
    self.x = indexPath.row + 1
    
    // Page Control: - Connect page control with index of visible cell
    // When user dragging/swiping
    self.pagesControl.currentPage = indexPath.row
    
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TranSactionDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return datasource!.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "TransactionHeaderTableViewCell") as? TransactionHeaderTableViewCell else { return UIView() }
    headerCell.titleDayLabel.text = datasource![section].name
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let items = datasource![section]
    return items.tranDefault.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let defaultDatasource = datasource![indexPath.section].tranDefault
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TranDefaultCell", for: indexPath) as? TranDefaultCell else { return UITableViewCell() }
    
    cell.iconTranImageView.image = defaultDatasource[indexPath.row].iconImage
    cell.titleTranLabel.text = defaultDatasource[indexPath.row].titleTranString
    cell.subTitleTranLabel.text = defaultDatasource[indexPath.row].subTitleTranString
    cell.priceTranLabel.text = defaultDatasource[indexPath.row].priceTranString
    tableView.rowHeight = 70
    return cell
    
  }
}
