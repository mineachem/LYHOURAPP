//
//  SlidebarMenuViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SideMenu
import SwinjectStoryboard

class SlidebarMenuViewController: BaseViewController {
  
  @IBOutlet var backgroundView: UIView!
  @IBOutlet weak var slidemenuTableView: UITableView!
  
  //header cell
  private var headerCell = [[String: AnyObject]]()
  private var headerContent: [String: AnyObject]!
  
  //content Cell
  private var iconImage = [ UIImage(named: "verify-user-white"),
                    UIImage(named: "verify-user-white"),
                    UIImage(named: "ic_redeem"),
                    UIImage(named: "machant"),
                    UIImage(named: "account-statement"),
                    UIImage(named: "exchange"),
                    UIImage(named: "logout"),
                    UIImage(named: "ic_settings"),
                    UIImage(named: "ic_help"),
                    UIImage(named: "ic_about")
  ]
  
  private enum TitleCell: String {
    case profile = "Profile"
    case verifyUser = "Verify User"
    case redeemVoucher = "Redeem Voucher"
    case applyMarchant = "Apply For Marchant"
    case accountStatment = "Account Statement"
    case exchangeRate = "Exchange Rage"
    case logout = "Sign Out"
    case setting = "Setting"
    case help = "Help"
    case aboutUs = "About Us"
  }
  
  private var titleCellContents = [String]()
  private var selectedTitle = ""
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupHeaderContent()
    setupTitleCell()
    setupTableView()
  }
}

// MARK: - Private Members
private extension SlidebarMenuViewController {
  func setupTitleCell() {
    titleCellContents = [TitleCell.profile.rawValue, TitleCell.verifyUser.rawValue,
                         TitleCell.redeemVoucher.rawValue, TitleCell.applyMarchant.rawValue,
                         TitleCell.accountStatment.rawValue, TitleCell.exchangeRate.rawValue,
                         TitleCell.logout.rawValue, TitleCell.setting.rawValue,
                         TitleCell.help.rawValue, TitleCell.aboutUs.rawValue]
  }
  
  func setupHeaderContent() {
    headerContent = ["image"  : #imageLiteral(resourceName: "tousles_jourslogo"),
                     "name"   : "Adolf Dsilva",
                     "phone"  : "010 69 01",
                     "email"  : "adolfdsilva@gmail.com"
      ] as [String : AnyObject]
    
    headerCell.append(headerContent)
  }
  
  func setupTableView() {
    slidemenuTableView.delegate = self
    slidemenuTableView.dataSource = self
    
    slidemenuTableView.register(UINib(nibName: "SlidebarHeaderCell", bundle: nil), forCellReuseIdentifier: "SlidebarHeaderCell")
    slidemenuTableView.register(UINib(nibName: "SlidebarContentCell", bundle: nil), forCellReuseIdentifier: "SlidebarContentCell")
    slidemenuTableView.tableHeaderView?.backgroundColor = UIColor.rgbColor(red: 34, green: 44, blue: 49)
    slidemenuTableView.tableFooterView?.backgroundColor = UIColor.rgbColor(red: 34, green: 44, blue: 49)
  }
  
  //swiftlint:disable cyclomatic_complexity
  func showScreen(with title: String) {
    switch title {
    case TitleCell.profile.rawValue:
      print(title)
      presentController(SwinjectStoryboard.initController(withIdentifier: ControllerName.profile.rawValue, fromStoryboard: StoryboardName.profile.rawValue))
    case TitleCell.verifyUser.rawValue:
      print(title)
      presentController(SwinjectStoryboard.initController(withIdentifier: ControllerName.contentVerifyPager.rawValue, fromStoryboard: StoryboardName.verify.rawValue))
    case TitleCell.redeemVoucher.rawValue:
      print(title)
    case TitleCell.applyMarchant.rawValue:
      print(title)
    case TitleCell.accountStatment.rawValue:
      print(title)
    case TitleCell.exchangeRate.rawValue:
      print(title)
    case TitleCell.logout.rawValue:
      signOut(from: self)
    case TitleCell.setting.rawValue:
      print(title)
      presentController(SwinjectStoryboard.initController(withIdentifier: ControllerName.setting.rawValue, fromStoryboard: StoryboardName.setting.rawValue))
    case TitleCell.help.rawValue:
      print(title)
    case TitleCell.aboutUs.rawValue:
      print(title)
    default:
      break
    }
  }
  
  func presentController(_ controller: UIViewController) {
    let navController = UINavigationController(rootViewController: controller)
    present(navController, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension SlidebarMenuViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleCellContents.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      tableView.separatorStyle = .singleLineEtched
      guard let sliderHeaderCell = tableView.dequeueReusableCell(withIdentifier: "SlidebarHeaderCell") as?  SlidebarHeaderCell else { return UITableViewCell() }
      let headerArray = headerCell[indexPath.row]
      sliderHeaderCell.profileImageView.image = headerArray["image"] as? UIImage
      sliderHeaderCell.nameLabel.text = headerArray["name"] as? String
      sliderHeaderCell.phonenumLabel.text = headerArray["phone"] as? String
      sliderHeaderCell.emailLabel.text = headerArray["email"] as? String
      return sliderHeaderCell
    }
    
    if indexPath.row == 6 {
      tableView.separatorStyle = .singleLineEtched
    } else {
      tableView.separatorStyle = .none
    }
    
    guard let slidebarContentCell = tableView.dequeueReusableCell(withIdentifier: "SlidebarContentCell") as? SlidebarContentCell else { return UITableViewCell() }
    slidebarContentCell.iconImageView.image = iconImage[indexPath.row]
    slidebarContentCell.contentTitleLabel.text = titleCellContents[indexPath.row]
    return slidebarContentCell
  }
}

// MARK: - UITableViewDelegate
extension SlidebarMenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
    selectedTitle = indexPath.row == 0 ? TitleCell.profile.rawValue : titleCellContents[indexPath.row]
    showScreen(with: selectedTitle)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
        return 200
      }
      return 180
    } else {
      return UIDevice.isPhone5SE ? 40 : 50
    }
  }
}
