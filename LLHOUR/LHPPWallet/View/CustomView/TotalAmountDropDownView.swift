//
//  DropDownView.swift
//  LHPPWallet
//
//  Created by Visal Va on 10/4/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

class TotalAmountDropDownView: CustomUIView, UITableViewDelegate, UITableViewDataSource {
  
  var dropDownOptions = [String]()
  var detailsDropDownOptions = [String]()
  
  var tableView = UITableView()
  
  weak var delegate: DropDownProtocol!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    tableView.backgroundColor = .white
    backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    addSubview(tableView)
    tableView.register(UINib(nibName: "TotalAmountCell", bundle: nil), forCellReuseIdentifier: TotalAmountCell.identifier)
    
    tableView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -12).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 12).isActive = true
    tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dropDownOptions.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44.0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalAmountCell.identifier, for: indexPath) as? TotalAmountCell else { return UITableViewCell() }
    cell.titleFeeLabel.text = dropDownOptions[indexPath.row]
    cell.feeLabel.text = detailsDropDownOptions[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
}
