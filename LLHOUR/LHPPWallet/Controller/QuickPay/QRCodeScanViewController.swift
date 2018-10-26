//
//  QRCodeScanViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/1/18.
//  Copyright © 2018 IG. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanViewController: UIViewController {
  
  private var captureSession = AVCaptureSession()
  private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  private var qrCodeFrameView: UIView?
  
  @IBOutlet weak var effectFront: UIView!
  var transactionAPI: TransactionAPI!
  var isFromProfileScreen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupClearNavigation()
    setupInputDevice()
    setupUI()
  }
  
  @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backgroundColor = UIColor.colorFromHex("2667A4")
    UIApplication.shared.statusBarView?.backgroundColor = UIColor.colorFromHex("2667A4")
  }
}

extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if metadataObjects.isEmpty {
      qrCodeFrameView?.frame = .zero
      print("No QR code is detected")
      return
    }
    
    //swiftlint:disable force_cast
    // Get the metadata object.
    let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
    
    if metadataObj.type == AVMetadataObject.ObjectType.qr {
      // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
      let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
      qrCodeFrameView?.frame = barCodeObject!.bounds
      
      if metadataObj.stringValue != nil {
        print(metadataObj.stringValue ?? "")
      }
    }
  }
}

private extension QRCodeScanViewController {
  func setupUI() {
    effectFront.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    // Initialize QR Code Frame to highlight the QR code
    qrCodeFrameView = UIView()
    
    if let qrCodeFrameView = qrCodeFrameView {
      qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
      qrCodeFrameView.layer.borderWidth = 2
      view.addSubview(qrCodeFrameView)
      view.bringSubviewToFront(qrCodeFrameView)
    }
    
    if isFromProfileScreen {
      let backButtonItem = UIBarButtonItem(image: UIImage(named: "backspace_white_24pt"), style: .plain, target: self, action: #selector(handleGoBack))
      navigationItem.leftBarButtonItem = backButtonItem
    }
  }
  
  @objc func handleGoBack() {
    dismiss(animated: true, completion: nil)
  }
  
  func setupInputDevice() {
    // Get the back-facing camera for capturing videos
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera], mediaType: AVMediaType.video, position: .back)
    
    guard let captureDevice = deviceDiscoverySession.devices.first else {
      print("Failed to get the camera device")
      return
    }
    
    do {
      // Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)
      
      // Set the input device on the capture session.
      captureSession.addInput(input)
      
      // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetadataOutput)
      
      // Set delegate and use the default dispatch queue to execute the call back
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
      
      // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      videoPreviewLayer?.frame = view.layer.bounds
      view.layer.addSublayer(videoPreviewLayer!)
      
      // Start video capture.
      captureSession.startRunning()
    } catch {
      // If any error occurs, simply print it out and don't continue any more.
      print(error)
      return
    }
  }
}
