//
//  BaseViewController.swift
//  LHPP Wallet
//
//  Created by Visal Va on 9/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwinjectStoryboard

class BaseViewController: UIViewController {
  
  var activityIndicatorView: NVActivityIndicatorView!
  
  // MARK: - Override Member
  override func viewDidLoad() {
    super.viewDidLoad()
    registerKeyboardNotification()
    setupActivityIndicatorView()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  // MARK: - Public Members
  func showHomeController(authModel: AuthViewModel, authResponse: AuthResponse) {
    guard let homeController = SwinjectStoryboard.initController(withIdentifier: ControllerName.home.rawValue, fromStoryboard: StoryboardName.home.rawValue) as? HomeViewController else { return }
    homeController.authResponse = authResponse
    homeController.authModel = authModel
    navigationController?.pushViewController(homeController, animated: true)
  }
  
  func removeKeyboardNotification() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = .clear
    UIApplication.shared.statusBarView?.backgroundColor = .clear
  }
  
  func signOut(from controller: UIViewController) {
    let alertController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
    let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let logoutAction = UIAlertAction(title: "Sign Out", style: .default) { [weak self] (_) in
      if type(of: controller) == EnterPINController.self {
        self?.showLoginController()
      } else {
        self?.dismiss(animated: true) {
          self?.showLoginController()
        }
      }
    }
    alertController.addAction(noAction)
    alertController.addAction(logoutAction)
    controller.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - NVActivityIndicatorViewable
extension BaseViewController: NVActivityIndicatorViewable {
  func showActivityView(message: String,
                        messageColor: UIColor,
                        minimumDisplayTime: Int? = nil,
                        completion: @escaping () -> Void) {
    let size = UIDevice.isPhone5SE ? CGSize(width: 40, height: 40) : CGSize(width: 60, height: 60)
    let backgroundColor = UIColor.black.withAlphaComponent(0.4)
    let fontSize: CGFloat = UIDevice.isPhone5SE ? 15 : 17
    let font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    let displayTime = minimumDisplayTime ?? 1
    startAnimating(size, message: message, messageFont: font, type: .ballClipRotatePulse, minimumDisplayTime: displayTime, backgroundColor: backgroundColor, textColor: .white) { (_) in
      completion()
    }
  }
}

// MARK: - Private Members
private extension BaseViewController {
  func showLoginController() {
    guard let window = UIApplication.shared.keyWindow else { return }
    let loginController = SwinjectStoryboard.initController(withIdentifier: ControllerName.login.rawValue, fromStoryboard: StoryboardName.register.rawValue)
    UserDefaults.resetAllValues()
    
    UIView.transition(with: window, duration: 0.5, options: .showHideTransitionViews, animations: {
      window.rootViewController = UINavigationController(rootViewController: loginController)
    }, completion: nil)
  }
  
  func setupActivityIndicatorView() {
    let rect = CGRect(center: view.center, size: CGSize(width: 60, height: 60))
    activityIndicatorView = NVActivityIndicatorView(frame: rect, type: .ballClipRotatePulse)
    view.addSubview(activityIndicatorView)
  }
  
  func registerKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }
  
  @objc func keyboardWillChange(notification: Notification) {
    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    switch notification.name {
    case UIResponder.keyboardWillShowNotification, UIResponder.keyboardWillChangeFrameNotification:
      view.frame.origin.y = -keyboardRect.height + (keyboardRect.height / 2 + 60)
    case UIResponder.keyboardWillHideNotification:
      view.frame.origin.y = 0
    default: break
    }
  }
}
