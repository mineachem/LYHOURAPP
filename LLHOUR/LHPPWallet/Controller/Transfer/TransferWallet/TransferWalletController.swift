//
//  TransferWalletController.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/4/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwinjectStoryboard

class TransferWalletController: BaseViewController {
  
  @IBOutlet weak var mobileNumberTextField: PhoneNumberTextField!
  @IBOutlet weak var contactImageView: UIImageView! {
    didSet {
      contactImageView.layer.borderWidth = 2
      contactImageView.layer.borderColor = UIColor.darkBlue.cgColor
      contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2
      contactImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var totalAmountView: CustomUIView!
  @IBOutlet weak var totalAmountViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var openImageView: UIImageView!
  @IBOutlet weak var tranferAmountTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func submit(_ sender: UIButton) {
  }
  
  @IBAction func scanQR(_ sender: UIButton) {
    let topupController = SwinjectStoryboard.initController(withIdentifier: ControllerName.qrCodeScanController.rawValue, fromStoryboard: StoryboardName.quickPay.rawValue)
    navigationController?.pushViewController(topupController, animated: true)
  }
  
  @IBAction func showContacts(_ sender: UIButton) {
    guard let contactsListController = SwinjectStoryboard.initController(withIdentifier: ControllerName.contactsListController.rawValue, fromStoryboard: StoryboardName.transfer.rawValue) as? ContactsListController else { return }
    contactsListController.contactSelectionDelegate = self
    navigationController?.pushViewController(contactsListController, animated: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  deinit {
    removeKeyboardNotification()
  }
}

private extension TransferWalletController {
  func setupUI() {
    openImageView.isUserInteractionEnabled = true
    openImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSubmitController)))
    mobileNumberTextField.delegate = self
    createToolBar()
    if UIDevice.isPhoneXs || UIDevice.isPhoneXR || UIDevice.isPhoneXsMax {
      totalAmountViewBottomConstraint.constant = -63 * 2
    } else {
      totalAmountViewBottomConstraint.constant = -63
    }
  }
  
  @objc func openSubmitController() {
    let submitController = SwinjectStoryboard.initController(withIdentifier: ControllerName.submitController.rawValue, fromStoryboard: StoryboardName.transfer.rawValue)
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    transition.type = .push
    transition.subtype = .fromTop
    navigationController?.view.layer.add(transition, forKey: kCATransition)
    navigationController?.pushViewController(submitController, animated: false)
  }
  
  // create a toolbar
  func createToolBar() {
    let tranferButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleMoveNext))
    let tranferToolbar = UIToolbar()
    tranferToolbar.initToolBar(with: tranferButton)
    tranferAmountTextField.inputAccessoryView = tranferToolbar
    let mobileButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDismisKeyboard))
    let mobileToolbar = UIToolbar()
    mobileToolbar.initToolBar(with: mobileButton)
    mobileNumberTextField.inputAccessoryView = mobileToolbar
  }
  
  @objc func handleDismisKeyboard() {
    view.endEditing(true)
  }
  
  @objc func handleMoveNext() {
    mobileNumberTextField.becomeFirstResponder()
  }
}

extension TransferWalletController: ContactSelectionProtocol {
  func selectContact(contact: PhoneContact) {
    contactImageView.image = contact.image
    mobileNumberTextField.text = contact.mobileNumber
    fullNameLabel.text = contact.fullName
  }
}

extension TransferWalletController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    // return true if the replacementString only contains numeric characters
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
}
