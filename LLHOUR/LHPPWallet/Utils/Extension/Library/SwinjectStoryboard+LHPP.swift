//
//  SwinjectStoryboard+LHPP.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/18/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import SwinjectStoryboard
import Swinject
import SideMenu

// MARK: - Public Members
extension SwinjectStoryboard {
  // MARK: - SwinjectStoryboard Setup
  @objc class func setup() {
    registerService()
    registerController()
  }
  
  @objc static func initController(withIdentifier identifier: String, fromStoryboard name: String) -> UIViewController {
    return storyboard(withName: name).instantiateViewController(withIdentifier: identifier)
  }
}

// MARK: - Private Members
private extension SwinjectStoryboard {
  // MARK: - Register Services
  class func registerService() {
    let container = SwinjectStoryboard.defaultContainer
    container.register(UserClientAPI.self) { _ in UserClientAPI()}.inObjectScope(.container)
    container.register(UserAuthAPI.self) { r in UserAuthAPI(api: r.resolve(UserClientAPI.self)!)}.inObjectScope(.container)
    
    container.register(TransactionClientAPI.self) { _ in TransactionClientAPI()}.inObjectScope(.container)
    container.register(TransactionAPI.self) { r in
      TransactionAPI(api: r.resolve(TransactionClientAPI.self)!)}.inObjectScope(.container)
    
    container.register(UtilityClientAPI.self) { _ in UtilityClientAPI()}.inObjectScope(.container)
    container.register(UtilityAPI.self) { r in UtilityAPI(api: r.resolve(UtilityClientAPI.self)!)}.inObjectScope(.container)
    
    container.register(UploadingDocumentClientAPI.self) { _ in
      UploadingDocumentClientAPI()}.inObjectScope(.container)
    container.register(UploadingDocAPI.self) { r in UploadingDocAPI(api: r.resolve(UploadingDocumentClientAPI.self)!)}.inObjectScope(.container)
  }
  
  // MARK: - Register Controllers
  class func registerController() {
    let container = defaultContainer
    container.storyboardInitCompleted(UIViewController.self) { (_, _) in }
    container.storyboardInitCompleted(UINavigationController.self) { (_, _) in }
    container.storyboardInitCompleted(UISideMenuNavigationController.self) { (_, _) in }
    container.storyboardInitCompleted(SlidebarMenuViewController.self) { (_, _) in }
    controllersFromRegisterStorybaord(with: container)
    controllersFromHomeStorybaord(with: container)
    controllersFromTransferStoryboard(with: container)
    controllersFromTopUpStoryboard(with: container)
    controllersFromAddMoneyStoryboard(with: container)
    controllersFromAddNewStoryboard(with: container)
    controllersFromQuickPayStoryboard(with: container)
    controllersFromNotificationStoryboard(with: container)
    controllersFromProfileStoryboard(with: container)
    controllersFromVerifyStoryboard(with: container)
    controllersFromSettingStoryboard(with: container)
  }
  
  class func controllersFromProfileStoryboard(with container: Container) {
    container.storyboardInitCompleted(ProfileViewController.self) { (resolver, controller) in
      controller.apiUpload = resolver.resolve(UploadingDocAPI.self)!
    }
    container.storyboardInitCompleted(ManageRecipientsTableViewController.self) { (_, _) in }
    container.storyboardInitCompleted(AccountDetailViewController.self) { (_, _) in }
  }
  
  class func controllersFromVerifyStoryboard(with container: Container) {
    container.storyboardInitCompleted(ContentVerifyPagerViewController.self) { (_, _) in }
    container.storyboardInitCompleted(CardViewController.self) { (_, _) in }
    container.storyboardInitCompleted(ManualTableViewController.self) { (_, _) in }
  }
  
  class func controllersFromSettingStoryboard(with container: Container) {
    container.storyboardInitCompleted(SettingTableViewController.self) { (_, _) in }
  }
  
  class func controllersFromRegisterStorybaord(with container: Container) {
    container.storyboardInitCompleted(LoginPasswordViewController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(SendSMSViewController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(VerificationViewController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(RegisterViewController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(EnterPINController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(ContentTopupPagerViewController.self) { (_, _) in }
    container.storyboardInitCompleted(AddNewWalletTableViewController.self) { (_, _) in }
    container.storyboardInitCompleted(DigitTableViewController.self) { (_, _) in }
    container.storyboardInitCompleted(QRCodeScanViewController.self) { (_, _) in }
  }
  
  class func controllersFromTransferStoryboard(with container: Container) {
    container.storyboardInitCompleted(TransferController.self) { (_, _) in }
    container.storyboardInitCompleted(TransferWalletController.self) { (_, _) in }
    container.storyboardInitCompleted(SentToCardViewController.self) { (_, _) in }
  }
  
  class func controllersFromHomeStorybaord(with container: Container) {
    container.storyboardInitCompleted(HomeViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
      controller.utilityAPI = resolver.resolve(UtilityAPI.self)!
    }
  }
  
  class func controllersFromAddMoneyStoryboard(with container: Container) {
    container.storyboardInitCompleted(ContentAddMoneyPagerViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
    container.storyboardInitCompleted(DigitTableViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
    container.storyboardInitCompleted(AgentViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
  }
  
  class func controllersFromAddNewStoryboard(with container: Container) {
    container.storyboardInitCompleted(ContentAddPagerNewViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
    container.storyboardInitCompleted(AddNewWalletTableViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
  }
  
  class func controllersFromTopUpStoryboard(with container: Container) {
    container.storyboardInitCompleted(ContentTopupPagerViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
    container.storyboardInitCompleted(TransactionPINController.self) { (resolver, controller) in
      controller.userAuthAPI = resolver.resolve(UserAuthAPI.self)!
    }
    container.storyboardInitCompleted(VoucherTableViewController.self) { (_, _) in }
    container.storyboardInitCompleted(InstantTableViewController.self) { (_, _) in }
    container.storyboardInitCompleted(PaymentSuccesfullViewController.self) { (_, _) in }
    container.storyboardInitCompleted(ContactsListController.self) { (_, _) in }
  }
  
  class func controllersFromQuickPayStoryboard(with container: Container) {
    container.storyboardInitCompleted(QRCodeScanViewController.self) { (resolver, controller) in
      controller.transactionAPI = resolver.resolve(TransactionAPI.self)!
    }
  }
  
  class func controllersFromNotificationStoryboard(with container: Container) {
    container.storyboardInitCompleted(NotificationTableViewController.self) { (_, _) in }
  }
  
  // MARK: - Init Storyboards
  // Register Storyboard
  @objc static func storyboard(withName name: String) -> SwinjectStoryboard {
    return SwinjectStoryboard.create(name: name, bundle: nil)
  }
}
