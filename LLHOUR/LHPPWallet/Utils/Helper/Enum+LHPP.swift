//
//  Enum+LHPP.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/14/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import Foundation

// MARK: - Storyboard Name
enum StoryboardName: String {
  case register     = "Register"
  case home         = "Home"
  case profile      = "Profile"
  case verify       = "Verify"
  case setting      = "Setting"
  case addMoney     = "AddMoney"
  case addNew       = "AddNew"
  case quickPay     = "QuickPay"
  case notification = "Notification"
  case transfer     = "Transfer"
  case topup        = "Topup"
}

// MARK: - Controller Identifier
enum ControllerName: String {
  // Register Storyboard
  case login         = "LoginPasswordViewController"
  case sendSMS       = "SendSMSViewController"
  case verification  = "VerificationViewController"
  case register      = "RegisterViewController"
  case enterPin      = "EnterPINController"
  case resetPassword = "ResetPasswordViewController"
  
  // Home Storyboard
  case home         = "HomeViewController"
  
  // Profile Storyboard
  case profile      = "ProfileViewController"
  case accountDetailViewController = "AccountDetailViewController"
  case manageRecipientsController = "ManageRecipientsTableViewController"
  
  // Verify Storyboard
  case contentVerifyPager = "ContentVerifyPagerViewController"

  // Setting Storyboard
  case setting      = "SettingTableViewController"
  
  // AddMoney Storyboard
  case addMoneyPagerController = "AddMoneyPagerController"
  
  // AddNew Storyboard
  case contentAddPagerController = "ContentAddPagerNewViewController"
  case addNewWalletController = "AddNewWalletTableViewController"
  
  // QuickPay Storyboard
  case qrCodeScanController = "QRCodeScanViewController"
  
  // Notification Storyboard
  case notificationController = "NotificationController"
  
  // Transfer Storyboard
  case transferController = "TransferController"
  case submitController = "SubmitController"
  case contactsListController = "ContactsListController"
  
  // Topup Storyboard
  case contentTopupController = "ContentTopupPagerViewController"
  case transactionPINController = "TransactionPINController"
  case paymentSuccesfulController = "PaymentSuccesfullViewController"
}
