//
//  LanguageView.swift
//  LHPPWallet
//
//  Created by Visal Va on 9/14/18.
//  Copyright © 2018 Visal Va. All rights reserved.
//

import UIKit

protocol Langauge: class {
  func change(language: String)
}

class LanguageController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var languageView: UIView! {
    didSet {
      languageView.layer.cornerRadius = 5
      languageView.layer.borderColor = UIColor.rgbColor(red: 48, green: 113, blue: 175).cgColor
      languageView.layer.borderWidth = 1
      languageView.layer.masksToBounds = true
    }
  }
  
  @IBOutlet weak var khmerLangugeButton: RadioButton!
  @IBOutlet weak var englishLanguageButton: RadioButton!
  @IBOutlet weak var khmerLabel: UILabel! {
    didSet {
      khmerLabel.isUserInteractionEnabled = true
      khmerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKhmerLabelTapped)))
    }
  }
  @IBOutlet weak var englishLabel: UILabel! {
    didSet {
      englishLabel.isUserInteractionEnabled = true
      englishLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEnglishLabelTapped)))
    }
  }
  
  private enum LanguageCode: String {
    case kh = "KH"
    case en = "EN"
  }
  
  weak var languageDelegate: Langauge?
  
  // MARK: - View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    if UserDefaults.value(forKey: .language) == nil {
      setupRadioButton(englishLanguageButton, isSelected: true)
    } else  if UserDefaults.value(forKey: .language) == LanguageCode.kh.rawValue {
      setupRadioButton(khmerLangugeButton, isSelected: true)
    } else {
      setupRadioButton(englishLanguageButton, isSelected: true)
    }
  }
  
  // MARK: - Action Members
  @IBAction func khmerLanguageButtonPressed(_ sender: RadioButton) {
    setupRadioButton(khmerLangugeButton, isSelected: true)
    UserDefaults.set(value: LanguageCode.kh.rawValue, forKey: .language)
    languageDelegate?.change(language: LanguageCode.kh.rawValue)
  }
  
  @IBAction func englishLanguageButtonPressed(_ sender: RadioButton) {
    setupRadioButton(englishLanguageButton, isSelected: true)
    UserDefaults.set(value: LanguageCode.en.rawValue, forKey: .language)
    languageDelegate?.change(language: LanguageCode.en.rawValue)
  }
}

// MARK: - Private Members
private extension LanguageController {
  func setupRadioButton(_ radioButton: RadioButton, isSelected: Bool) {
    if radioButton == khmerLangugeButton {
      englishLanguageButton.isSelected = !isSelected
      khmerLangugeButton.isSelected = isSelected
      UserDefaults.set(value: LanguageCode.kh.rawValue, forKey: .language)
    } else {
      khmerLangugeButton.isSelected = !isSelected
      englishLanguageButton.isSelected = isSelected
      UserDefaults.set(value: LanguageCode.en.rawValue, forKey: .language)
    }
  }
  
  @objc func handleKhmerLabelTapped() {
    khmerLanguageButtonPressed(khmerLangugeButton)
  }
  
  @objc func handleEnglishLabelTapped() {
    englishLanguageButtonPressed(englishLanguageButton)
  }
}
