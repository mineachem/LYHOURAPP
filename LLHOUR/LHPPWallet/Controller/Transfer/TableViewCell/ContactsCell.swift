//
//  ContactsCell.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/5/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
  
  @IBOutlet weak var contactImageView: UIImageView! {
    didSet {
      contactImageView.layer.borderWidth = 2
      contactImageView.layer.borderColor = UIColor.darkBlue.cgColor
      contactImageView.layer.cornerRadius = contactImageView.frame.size.width / 2
      contactImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var mobileNumber: UILabel!
  
  func configure(contact: PhoneContact) {
    if contact.image == nil {
      contactImageView.image = UIImage(named: "NA-Contacts")
    } else {
      contactImageView.image = contact.image
    }
    fullNameLabel.text = contact.fullName
    self.mobileNumber.text = contact.mobileNumber
  }
}

extension ContactsCell {
  static var identifier: String {
    return String(describing: ContactsCell.self)
  }
}
