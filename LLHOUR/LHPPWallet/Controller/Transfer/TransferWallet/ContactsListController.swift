//
//  ContactsListController.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/5/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit
import Contacts
import NVActivityIndicatorView

protocol ContactSelectionProtocol: class {
  func selectContact(contact: PhoneContact)
}

class ContactsListController: UITableViewController {
  
  private var contacts = [PhoneContact]()
  weak var contactSelectionDelegate: ContactSelectionProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let contactsCell = tableView.dequeueReusableCell(withIdentifier: ContactsCell.identifier, for: indexPath) as? ContactsCell else { return UITableViewCell() }
    let contact = contacts[indexPath.row]
    contactsCell.configure(contact: contact)
    return contactsCell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contact = contacts[indexPath.row]
    contactSelectionDelegate?.selectContact(contact: contact)
    navigationController?.popViewController(animated: true)
  }
}

private extension ContactsListController {
  func setupUI() {
    navigationItem.title = "Contacts"
    
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
    } else {
      
    }
    navigationItem.backBarButtonItem?.tintColor = .white
    tableView.register(UINib(nibName: "ContactsCell", bundle: nil), forCellReuseIdentifier: ContactsCell.identifier)
    
    if contacts.isEmpty {
      fetchContacts()
    }
  }
  
  private func fetchContacts() {
    print("Attempting to fetch contacts ...")
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { [weak self] (granted, err) in
      if let err = err {
        print("Failed to request access:", err)
        return
      }
      
      if granted {
        print("Access granted")
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
          try store.enumerateContacts(with: request, usingBlock: { (contact, _) in
            let fullName = contact.givenName + contact.familyName
            let mobileNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
            let contactImage: UIImage
            if let contactImageData = contact.imageData {
              contactImage = UIImage(data: contactImageData)!
            } else {
              contactImage = UIImage(named: "NA-Contacts")!
            }
            let contact = PhoneContact(fullName: fullName, mobileNumber: mobileNumber, image: contactImage)
            self?.contacts.append(contact)
          })
        } catch let err {
          print("Failed to enumerate contacts:", err)
        }
        
        self?.tableView.reloadData()
      } else {
        print("Access denied..")
        self?.tableView.reloadData()
      }
    }
  }
}
