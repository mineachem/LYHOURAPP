//
//  SettingTableViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/6/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import SwinjectStoryboard

class SettingTableViewController: UITableViewController {
  
  // MARK: - Properties
  @IBOutlet weak var switchPIN: UISwitch!
  @IBOutlet weak var switchFingerPrint: UISwitch!
  
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var flagImageView: UIImageView!
  
  private var headerString = ["General", "Account"]
  private var languageController: LanguageController!
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
  }
  
  // MARK: - Action Members
  
  @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - UITableViewDelegate & UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return headerString.count
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    subView.backgroundColor = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    let titleHeader = UILabel(frame: CGRect(x: 10, y: 15, width: subView.frame.width, height: 20))
    titleHeader.text = headerString[section]
    titleHeader.textColor = UIColor.red
    subView.addSubview(titleHeader)
    
    return subView
  }
  //swiftlint:disable cyclomatic_complexity
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
    
    if indexPath.section == 0 {
      print("Section: \(indexPath.section), Row: \(indexPath.row)")
      switch indexPath.row {
      case 0:
        print("Language")
        guard let navigationControllerView = navigationController?.view else { return }
        languageController = LanguageController(nibName: "LanguageController", bundle: Bundle.main)
        languageController.languageDelegate = self
        languageController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        languageController.view.frame = navigationControllerView.frame
        navigationControllerView.addSubview(languageController.view)
      case 1:
        print("Notifications")
      default: break
      }
    } else {
      print("Section: \(indexPath.section), Row: \(indexPath.row)")
      switch indexPath.row {
      case 0:
        print("Default Account")
      case 1:
        print("Change Login PIN")
      case 2:
        print("Transaction PIN")
      case 3:
        print("Use Fingerprint")
      case 4:
        performLogout()
      default: break
      }
    }
  }
}

private extension SettingTableViewController {
  func setupUI() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
    
    if let language = UserDefaults.value(forKey: .language) {
      displayLanguage(language)
    }
  }
  
  @objc func handleDismiss() {
    if languageController != nil {
      languageController.view.removeFromSuperview()
    }
  }
  
  func displayLanguage(_ text: String) {
    if text == "KH" {
      languageLabel.text = "ភាសាខ្មែរ"
      flagImageView.image = #imageLiteral(resourceName: "flag_kh")
    } else {
      flagImageView.image = #imageLiteral(resourceName: "us-flag")
      languageLabel.text = "English"
    }
  }
  
  func performLogout() {
    let alertController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
    let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let logoutAction = UIAlertAction(title: "Sign Out", style: .default) { [weak self] (_) in
      self?.dismiss(animated: true) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let loginController = SwinjectStoryboard.initController(withIdentifier: ControllerName.login.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? LoginPasswordViewController else { return }
        UserDefaults.resetAllValues()
        
        UIView.transition(with: window, duration: 0.5, options: .showHideTransitionViews, animations: {
          window.rootViewController = UINavigationController(rootViewController: loginController)
        }, completion: nil)
      }
    }
    alertController.addAction(noAction)
    alertController.addAction(logoutAction)
    present(alertController, animated: true, completion: nil)
  }
}

extension SettingTableViewController: Langauge {
  func change(language: String) {
    displayLanguage(language)
    
    if languageController != nil {
      languageController.view.removeFromSuperview()
    }
  }
}
