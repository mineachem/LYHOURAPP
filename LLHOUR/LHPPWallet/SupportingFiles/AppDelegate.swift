//
//  AppDelegate.swift
//  LHPP Wallet
//
//  Created by User on 7/3/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    //API KEY GOOGLE MAP
    GMSServices.provideAPIKey("AIzaSyCNQl6Hu87YSxDZtS_kvU0IHYsCFaehX1k")
    //API KEY GOOGLE PLACE
    GMSPlacesClient.provideAPIKey("AIzaSyCNQl6Hu87YSxDZtS_kvU0IHYsCFaehX1k")
    
    setupStatusAndNavigationBarStyle()
    setupRootViewController()
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "MM/dd/yyyy HH:mm:ss"
    let backgroundTime = dateFormater.string(from: Date())
    UserDefaults.set(value: backgroundTime, forKey: .backgroundTime)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if let backgroundTime = UserDefaults.value(forKey: .backgroundTime) {
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = "MM/dd/yyyy HH:mm:ss"
      let foregroundTime = dateFormater.string(from: Date())
      calculateBackgroundTime(backgroundTime, with: foregroundTime)
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

// MARK: - Private Member
private extension AppDelegate {
  func setupStatusAndNavigationBarStyle() {
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().barStyle = .black
  }
  
  func setupRootViewController() {
    window = UIWindow()
    let rootViewController: UIViewController
    if !UserDefaults.boolValue(forKey: .skipPIN) && UserDefaults.value(forKey: .sk) != nil && UserDefaults.value(forKey: .handle) != nil {
      rootViewController = SwinjectStoryboard.initController(withIdentifier: ControllerName.enterPin.rawValue, fromStoryboard: StoryboardName.register.rawValue)
    } else if UserDefaults.value(forKey: .sk) == nil || UserDefaults.value(forKey: .username) != nil {
      guard let loginController = SwinjectStoryboard.initController(withIdentifier: ControllerName.login.rawValue, fromStoryboard: StoryboardName.register.rawValue) as? LoginPasswordViewController else { return }
      if let username = UserDefaults.value(forKey: .username) {
        loginController.savedUsername = username
      }
      rootViewController = loginController
    } else {
      rootViewController = SwinjectStoryboard.initController(withIdentifier: ControllerName.home.rawValue, fromStoryboard: StoryboardName.home.rawValue)
    }
    window?.rootViewController = UINavigationController(rootViewController: rootViewController)
    window?.makeKeyAndVisible()
  }
  
  func calculateBackgroundTime(_ backgroundTime: String, with foregroundTime: String) {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "MM/dd/yyyy HH:mm:ss"
    guard let lastTime = dateFormater.date(from: foregroundTime), let todayTime = dateFormater.date(from: backgroundTime) else { return }
    
    let current = Calendar.current
    let lastSecondDiff = current.component(.second, from: lastTime)
    let lastMinuteDiff = current.component(.minute, from: lastTime)
    let todaySecondDiff = current.component(.second, from: todayTime)
    let todayMinuteDiff = current.component(.minute, from: todayTime)
    
    if todayMinuteDiff != lastMinuteDiff {
      setupRootViewController()
    } else {
      let secondDiff = lastSecondDiff - todaySecondDiff
      if secondDiff >= 15 {
        setupRootViewController()
      }
    }
  }
}
