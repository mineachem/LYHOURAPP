//
//  AgentViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/4/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class AgentViewController: UIViewController {
  
  @IBOutlet weak var googleMapView: GMSMapView!
  
  var transactionAPI: TransactionAPI!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGoogleMapInit()
  }
  
  func setupGoogleMapInit() {
    let camera = GMSCameraPosition.camera(withLatitude: 11.53319, longitude: 104.90968, zoom: 15.0)
    googleMapView.camera = camera
    googleMapView.settings.myLocationButton = true
    googleMapView.isMyLocationEnabled = true
    
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: 11.53319, longitude: 104.90968)
    marker.title = "My Place"
    marker.snippet = "IG"
    marker.map = googleMapView
    //swiftlint:disable discouraged_direct_init
    if UIDevice().userInterfaceIdiom == .phone {
      switch UIScreen.main.nativeBounds.height {
      case 1136:
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
      case 1334:
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
      case 1920, 2208:
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
      case 2436:
        googleMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
      default:
        print("unknown")
      }
    }
  }
}
