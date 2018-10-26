//
//  TypeYourPinViewController.swift
//  LHPP Wallet
//
//  Created by User on 7/26/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard

class TransactionPINController: UIViewController {
  
  @IBOutlet weak var pinTextField1: UITextField!
  @IBOutlet weak var pinTextField2: UITextField!
  @IBOutlet weak var pinTextField3: UITextField!
  @IBOutlet weak var pinTextField4: UITextField!
  @IBOutlet var numberPads: [UIButton]!
  @IBOutlet weak var pinDescriptionLabel: UILabel!
  
  private var textFields = [UITextField]()
  private var pin = ""
  
  var selectedAmount = 0
  var mobileNumber = ""
  var selectedNetwork = ""
  var userAuthAPI: UserAuthAPI!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  @IBAction func goBack(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func performOperation(_ sender: UIButton) {
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count < 4 {
      guard let title = sender.currentTitle, !title.isEmpty else { return }
      pin.append(title)
      textFields[pin.count - 1].text = title
    }
    
    if sender.currentImage == #imageLiteral(resourceName: "clear-symbol") {
      if pin.count == 0 {
        return
      }
      
      _ = pin.removeLast()
      textFields[pin.count].text = ""
    }
    
    if sender.currentImage != #imageLiteral(resourceName: "clear-symbol") && pin.count == 4 {
      performTopUp()
    }
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
}

private extension TransactionPINController {
  func setupUI() {
    setupPinTextField()
    setupClearNavigation()
    setupPinTextField()
    setupNumberPads()
    mobileNumber = mobileNumber.replacingOccurrences(of:"[^0-9]", with: "", options: .regularExpression)
    if UserDefaults.boolValue(forKey: .alreadyCreatedTransactionPIN) {
      pinDescriptionLabel.text = "Type your  PIN"
    } else {
      pinDescriptionLabel.text = "Create Transaction PIN"
    }
  }
  
  func setupPinTextField() {
    textFields = [pinTextField1, pinTextField2, pinTextField3, pinTextField4]
    textFields.forEach { (textField) in
      textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
      textField.isSecureTextEntry = true
      if UIDevice.isBiggestPhone {
        textField.font = UIFont.boldSystemFont(ofSize: 24)
      } else {
        textField.font = UIFont.boldSystemFont(ofSize: 16)
      }
    }
  }
  
  func setupNumberPads() {
    numberPads.forEach { (button) in
      button.titleLabel?.font = UIDevice.isPhone5SE ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.preferredFont(forTextStyle: .title1)
    }
  }
  
  func performTopUp() {
    if UserDefaults.boolValue(forKey: .alreadyCreatedTransactionPIN) {
      print("Call to Top Up")
    } else {
      print("Call to Update Credential first then call to Top up")
      updateCredential()
    }
    
    let paymentSuccessfulController = SwinjectStoryboard.initController(withIdentifier: ControllerName.paymentSuccesfulController.rawValue, fromStoryboard: StoryboardName.topup.rawValue)
    navigationController?.pushViewController(paymentSuccessfulController, animated: true)
  }
  
  func updateCredential() {
    guard let handle = UserDefaults.value(forKey: .handle) else { return }
    let updateCredential = UpdateCredentialViewModel(isFromLoggingIn: false, authByOTP: true, deviceId: UIDevice.deviceId, handle: handle, lang: "EN", tpin: pin, timeStamp: Date.javisDateFormat, sk: "")
    userAuthAPI.updateCredential(parameters: updateCredential.parameters, completion: { (error) in
      if let err = error {
        debugPrint(err)
        return
      }
      
      print("Successfully update")
      UserDefaults.set(value: true, forKey: .alreadyCreatedTransactionPIN)
    })
  }
}
