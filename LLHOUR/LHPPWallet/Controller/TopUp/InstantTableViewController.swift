//
//  InstantTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/11/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard
import PhoneNumberKit

class InstantTableViewController: UITableViewController {
  
  @IBOutlet weak var mobileNumberTextField: PhoneNumberTextField!
  @IBOutlet weak var oneDollarButton: RoundButton!
  @IBOutlet weak var twoDollarButton: RoundButton!
  @IBOutlet weak var fiveDollarButton: RoundButton!
  @IBOutlet weak var tenDollarButton: RoundButton!
  @IBOutlet weak var fifteenDollarButton: RoundButton!
  @IBOutlet weak var twentyDollarButton: RoundButton!
  
  var amountButtons = [RoundButton]()
  var selectedAmount = 0
  var selectedAmountButton: RoundButton!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Action Members
  @IBAction func recharge(_ sender: RoundButton) {
    guard let mobileNumber = mobileNumberTextField.text else { return }
    if mobileNumber.isEmpty || mobileNumber.count < 8 {
      alertMessage(title: "Error", message: "Your Mobile Number is not correct. Please try again.", on: self)
    } else if selectedAmount == 0 {
      alertMessage(title: "Error", message: "Please select amount that you want to top up.", on: self)
    } else {
      guard let typeYourPINController = SwinjectStoryboard.initController(withIdentifier: ControllerName.transactionPINController.rawValue, fromStoryboard: StoryboardName.topup.rawValue) as? TransactionPINController else { return }
      typeYourPINController.selectedAmount = selectedAmount
      typeYourPINController.mobileNumber = mobileNumber
      navigationController?.pushViewController(typeYourPINController, animated: true)
    }
  }
  
  @IBAction func amountButtonTapped(_ sender: RoundButton) {
    amountButtons = [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton, fifteenDollarButton, twentyDollarButton]
    
    if sender.tag > amountButtons.count - 1 {
      return
    }
    
    selectedAmountButton = amountButtons.remove(at: sender.tag)
    selectedAmountButton.backgroundColor = .redRoundButton
    selectedAmountButton.setTitleColor(.white, for: .normal)
    selectedAmount = selectAmount(index: selectedAmountButton.tag)
    print(selectedAmount)
    
    amountButtons.forEach { (button) in
      button.backgroundColor = .white
      button.setTitleColor(.darkGray, for: .normal)
    }
  }
  
  @IBAction func showContacts(_ sender: UIButton) {
    guard let showContactList = SwinjectStoryboard.initController(withIdentifier: ControllerName.contactsListController.rawValue, fromStoryboard: StoryboardName.transfer.rawValue) as? ContactsListController else { return }
    showContactList.contactSelectionDelegate = self
    navigationController?.pushViewController(showContactList, animated: true)
  }
  
  // MARK: - UITableView Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
  }
}

// MARK: - ContactSelectionProtocol
extension InstantTableViewController: ContactSelectionProtocol {
  func selectContact(contact: PhoneContact) {
    mobileNumberTextField.text = contact.mobileNumber
  }
}

// MARK: - Private Members
private extension InstantTableViewController {
  func setupUI() {
    createToolBar()
    mobileNumberTextField.delegate = self
    amountButtons = [oneDollarButton, twoDollarButton, fiveDollarButton, tenDollarButton, fifteenDollarButton, twentyDollarButton]
    selectedAmount = selectAmount(index: 0)
  }
  
  func createToolBar() {
    let mobileButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDismisKeyboard))
    let mobileToolbar = UIToolbar()
    mobileToolbar.initToolBar(with: mobileButton)
    mobileNumberTextField.inputAccessoryView = mobileToolbar
  }
  
  @objc func handleDismisKeyboard() {
    view.endEditing(true)
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

// MARK: - UITextFieldDelegate
extension InstantTableViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    // return true if the replacementString only contains numeric characters
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
  }
}
