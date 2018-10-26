//
//  HomeViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/10/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON
import SwinjectStoryboard

class HomeViewController: BaseViewController {
  
  // MARK: - Properties
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var menuItem: UIBarButtonItem!
  @IBOutlet weak var homeTableView: UITableView!
  @IBOutlet weak var bgSlideView: UIView!
  @IBOutlet weak var qrButton: RoundButton!
  @IBOutlet weak var qrButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var qrButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var homeTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var pageControllerBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var addLabel: UILabel!
  @IBOutlet weak var addNewLabel: UILabel!
  
  var authModel: AuthViewModel!
  var authResponse: AuthResponse!
  var transactionAPI: TransactionAPI!
  var utilityAPI: UtilityAPI!
  
  // Section Header
  private var headerHome = ["Services", "Favorites", "Offers"]
  
  // Logo of 3 row
  private var logoService = [UIImage(named: "ic_topup"),
                     UIImage(named:"ic-bill-pay"),
                     UIImage(named: "ic-transfer"),
                     UIImage(named: "ic-market")]
  private var logoFav = [UIImage(named: "add_fav")]
  private var logoOffer = [UIImage(named: "touslesbg"), UIImage(named: "touslesbg")]
  
  // Title 0f 3 row
  private var titleService = ["Top Up", "Bill Pay", "Transfer", "Market"]
  private var titleFav = [""]
  private var titleOffer = ["20% OFF", "30% OFF"]
  private var slides: [Slide] = []
  private var accounts = [AccountBalance]()
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchBalances()
    fetchOffers()
    setupUI()
    setupSideMenu()
    NotificationCenter.default.addObserver(self, selector: #selector(fetchBalances), name: NSNotification.Name(rawValue: "AddNewWalletNotification"), object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupClearNavigation()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AddNewWalletNotification"), object: nil)
  }
  
  // MARK: - Action Members
  @IBAction func addMoneyTapped(_ sender: UIButton) {
    let addMoneyController = SwinjectStoryboard.initController(withIdentifier: ControllerName.addMoneyPagerController.rawValue, fromStoryboard: StoryboardName.addMoney.rawValue)
    navigationController?.pushViewController(addMoneyController, animated: true)
  }
  
  @IBAction func goToQrcodeTapped(_ sender: RoundButton) {
    let qrCodeScanController = SwinjectStoryboard.initController(withIdentifier: ControllerName.qrCodeScanController.rawValue, fromStoryboard: StoryboardName.quickPay.rawValue)
    navigationController?.pushViewController(qrCodeScanController, animated: true)
  }
  
  @IBAction func addNewButton(_ sender: UIButton) {
    guard let addNewController = SwinjectStoryboard.initController(withIdentifier: ControllerName.contentAddPagerController.rawValue, fromStoryboard: StoryboardName.addNew.rawValue) as? ContentAddPagerNewViewController else { return }
    addNewController.authResponse = authResponse
    navigationController?.pushViewController(addNewController, animated: true)
  }
  
  @IBAction func notificationButtonTapped(_ sender: UIBarButtonItem) {
    let notificationController = SwinjectStoryboard.initController(withIdentifier: ControllerName.notificationController.rawValue, fromStoryboard: StoryboardName.notification.rawValue)
    navigationController?.pushViewController(notificationController, animated: true)
  }
  
  @IBAction func menuTapped(_ sender: UIBarButtonItem) {
    present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
  }
}

// MARK: - Private Members
private extension HomeViewController {
  @objc func fetchBalances() {
    accounts = []
    slides = []
    guard let response = authResponse, let handle = response.handle, let timeStamp = response.timeStamp, let authModel = self.authModel else { return }
    let balanceViewModel = BalanceInquiryViewModel(authModel: authModel, authResponse: response, acNo: "", deviceId: UIDevice.deviceId, handle: handle, lang: "EN", timeStamp: timeStamp)
    transactionAPI.inquireBalances(parameters: balanceViewModel.parameters) { [weak self] (values, error) in
      if let err = error {
        print(err)
        return
      }
      
      // Fetch Balances from Balance Inquiry API
      guard let balanceResponse = values, let handle = balanceResponse.handle else { return }
      UserDefaults.set(value: handle, forKey: .handle)
      self?.generateAccountBalances(balanceResponse.balances) {
        self?.setupSlides()
      }
      UserDefaults.removeValue(forKey: .fromRegister)
    }
  }
  
  func fetchOffers() {
    utilityAPI.fetchOffers(with: [:]) { (values, error) in
      if let err = error {
        debugPrint(err)
        return
      }
      
      print(values ?? "No Response")
    }
  }
  
  func generateAccountBalances(_ balances: [JSON], completion: () -> Void) {
    balances.forEach { (balance) in
      let account = AccountBalance(json: balance)
      self.accounts.append(account)
    }
    completion()
  }
  
  func setupUI() {
    setupSlides()
    setupTableView()
    setupLabel()
    
    if let authResponse = self.authResponse, let authUser = authResponse.user {
      let user = User(json: JSON(authUser))
      navigationItem.title = user.preferredName
    }

    if UIDevice.isBiggerPhone || UIDevice.isBiggestPhone {
      qrButtonHeightConstraint.constant = 60
      qrButtonWidthConstraint.constant = 60
      qrButton.cornerRadius = 30
      homeTableViewHeightConstraint.constant = 80
      pageControllerBottomConstraint.constant = 24
      addLabel.font = UIFont.preferredFont(forTextStyle: .callout)
      addNewLabel.font = UIFont.preferredFont(forTextStyle: .callout)
    } else {
      qrButtonHeightConstraint.constant = 50
      qrButtonWidthConstraint.constant = 50
      qrButton.cornerRadius = 25
      homeTableViewHeightConstraint.constant = 40
      pageControllerBottomConstraint.constant = 16
      addLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
      addNewLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
  }
  
  func setupLabel() {
    addNewLabel.isUserInteractionEnabled = true
    addNewLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewButton(_:))))
    addLabel.isUserInteractionEnabled = true
    addLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMoneyTapped(_:))))
  }
  
  func setupSlides() {
    scrollView.delegate = self
    slides = createSlides()
    setupSlideScrollView(slides: slides)
    
    pageControl.numberOfPages = slides.count
    pageControl.currentPage = 0
    view.bringSubviewToFront(pageControl)
  }
  
  func setupTableView() {
    homeTableView.delegate = self
    homeTableView.dataSource = self
    
    let headerNib = UINib(nibName: "HeaderHomeScreenCell", bundle: nil)
    homeTableView.register(headerNib, forCellReuseIdentifier: "HeaderHomeScreenCell")

    automaticallyAdjustsScrollViewInsets = false
  }
  
  func setupSideMenu() {
    // Define the menus
    SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
    if let navController = self.navigationController {
      SideMenuManager.default.menuAddPanGestureToPresent(toView: navController.navigationBar)
      SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navController.view)
    }
    SideMenuManager.default.menuPresentMode = .menuSlideIn
    SideMenuManager.default.menuShadowColor = .black
    SideMenuManager.default.menuEnableSwipeGestures = true
    SideMenuManager.default.menuAnimationBackgroundColor = .clear
  }
  
  func createSlides() -> [Slide] {
    var slides = [Slide]()
    accounts.forEach { (account) in
      guard let slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as? Slide else { return }
      if let balanceAmount = account.balanceAvailable, let currency = account.currency, let cardNumber = account.value {
        slide.pricesLabel.text = "\(balanceAmount)"
        slide.currencyLabel.text = "\(currency) Wallet"
        slide.cardNumberLabel.text = "\(String(cardNumber.suffix(4)))"
      } else {
        slide.pricesLabel.text = ""
        slide.currencyLabel.text = "USD"
        slide.cardNumberLabel.text = ""
      }
      slides.append(slide)
    }
    return slides
  }
  
  func setupSlideScrollView(slides: [Slide]) {
    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.contentSize.height)
    scrollView.isPagingEnabled = true
    
    for i in 0 ..< slides.count {
      slides[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
      scrollView.addSubview(slides[i])
    }
  }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = Int(pageIndex)
  }
}

// MARRK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderHomeScreenCell") as? HeaderHomeScreenCell else { return UIView() }
    headerCell.leftTitleLabel.text = headerHome[section]
    if section == 2 {
      headerCell.showAllButton.alpha = 1
      headerCell.showAllButton.setTitle("View All", for: .normal)
    }
    
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return  100
    } else if indexPath.section == 1 {
      return 100
    } else if indexPath.section == 2 {
      return 120
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return headerHome.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let serviceContentCell = tableView.dequeueReusableCell(withIdentifier: "ServiceContentTableViewCell", for: indexPath) as? ServiceContentTableViewCell else { return UITableViewCell() }
      serviceContentCell.serviceContentView.dataSource = self
      serviceContentCell.serviceContentView.delegate = self
      return serviceContentCell
    } else if indexPath.section == 1 {
      guard let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
      favoriteCell.favoriteContentView.dataSource = self
      favoriteCell.favoriteContentView.dataSource = self
      return favoriteCell
    } else if indexPath.section == 2 {
      guard let offersCell = tableView.dequeueReusableCell(withIdentifier: "OffersTableViewCell", for: indexPath) as? OffersTableViewCell else { return UITableViewCell() }
      offersCell.offerContentView.dataSource = self
      offersCell.offerContentView.delegate = self
      return offersCell
    }
    return UITableViewCell()
  }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView.tag == 0 {
      return titleService.count
    } else if collectionView.tag == 1 {
      return titleFav.count
    } else if collectionView.tag == 2 {
      return titleOffer.count
    } else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView.tag {
    case 0:
      guard let serviceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as? ServicesCollectionViewCell else { return UICollectionViewCell() }
      serviceCell.configureCell(image: logoService[indexPath.item], title: titleService[indexPath.item])
      return serviceCell
    case 1:
      guard let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
      favoriteCell.configureCell(image: logoFav[indexPath.item], title: titleFav[indexPath.item])
      return favoriteCell
    case 2:
      guard let offersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCollectionViewCell", for: indexPath) as? OffersCollectionViewCell else { return UICollectionViewCell() }
      offersCell.bgOfferImageView.image = logoOffer[indexPath.item]
      offersCell.discountLabel.text = titleOffer[indexPath.item]
      return offersCell
    default:
      return UICollectionViewCell()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item)
    if indexPath.item == 0 {
      guard let topupController = SwinjectStoryboard.initController(withIdentifier: ControllerName.contentTopupController.rawValue, fromStoryboard: StoryboardName.topup.rawValue) as? ContentTopupPagerViewController else { return }
      topupController.authResponse = authResponse
      navigationController?.pushViewController(topupController, animated: true)
    } else if indexPath.item == 2 {
      let transferController = SwinjectStoryboard.initController(withIdentifier: ControllerName.transferController.rawValue, fromStoryboard: StoryboardName.transfer.rawValue)
      navigationController?.pushViewController(transferController, animated: true)
    }
  }
}
