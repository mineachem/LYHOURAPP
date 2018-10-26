//
//  ProfileViewController.swift
//  LHPP Wallet
//
//  Created by User on 8/2/18.
//  Copyright © 2018 IG. All rights reserved.
//

import SwinjectStoryboard

class ProfileViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var logoImageView: RoundedWhiteBgImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var priceLoyaltyLabel: UILabel!
  @IBOutlet weak var codeReferalLabel: UILabel!
  @IBOutlet weak var profileTableView: UITableView!
  @IBOutlet weak var takePhoto: RoundButton!
  @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHieghtConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cameraWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var cameraHeightConstraint: NSLayoutConstraint!
  
  let iconImage = [#imageLiteral(resourceName: "account"), #imageLiteral(resourceName: "verify_user"), #imageLiteral(resourceName: "group"), #imageLiteral(resourceName: "wallet")]
  let titleProfile = ["Account Detail", "Verify user", "Manage Reciptiens", "Wallet Type"]
  var authResponse: AuthResponse!
  var documents:[Document]!
  var uploadingAvatar: UploadingAvatarViewModel!
  var apiUpload: UploadingDocAPI!
  
  var stringImage: String!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    profileTableView.delegate = self
    profileTableView.dataSource = self
  
    setupClearNavigation()
    setupPhotoGallary()
    setupProfileImage()
    
  }
  
  func setupProfileImage() {
    if UIDevice.isPhoneXR || UIDevice.isPhoneXs || UIDevice.isPhoneXsMax || UIDevice.isBiggestPhone {
      imageWidthConstraint.constant = 90
      imageHieghtConstraint.constant = 90
      
      cameraWidthConstraint.constant = 24
      cameraHeightConstraint.constant = 24
      
      takePhoto.cornerRadius = 12
      
    } else {
      imageWidthConstraint.constant = 64
      imageHieghtConstraint.constant = 64
      
      cameraWidthConstraint.constant = 18
      cameraHeightConstraint.constant = 18
      
      takePhoto.cornerRadius = 8
    }
  }
  func setupPhotoGallary(){
    let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
    logoImageView.isUserInteractionEnabled = true
    logoImageView.addGestureRecognizer(imageTap)
    takePhoto.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
  }
  
  func setupClearNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  //MARK: Take photo on library
  @objc func openImagePicker(){
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    
    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
      
      if UIImagePickerController.isSourceTypeAvailable(.camera){
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
      }else {
        print("Camera not available")
      }
      
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
      imagePickerController.sourceType = .photoLibrary
      self.present(imagePickerController, animated: true)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    self.present(actionSheet, animated: true)
  }
  
  @IBAction func upgradeButtonTapped(_ sender: UIButton) {
    
  }
  
  @IBAction func backItemTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func scanQRCode(_ sender: UIButton) {
    guard let scanQRController = SwinjectStoryboard.initController(withIdentifier: ControllerName.qrCodeScanController.rawValue, fromStoryboard: StoryboardName.quickPay.rawValue) as? QRCodeScanViewController else { return }
    scanQRController.isFromProfileScreen = true
    navigationController?.present(UINavigationController(rootViewController: scanQRController), animated: true, completion: nil)
  }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleProfile.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let profilecontentCell = tableView.dequeueReusableCell(withIdentifier: "ProfileContentCell", for: indexPath) as? ProfileContentCell else { return UITableViewCell() }
    profilecontentCell.iconImageView.image = iconImage[indexPath.row]
    profilecontentCell.titleLabel.text = titleProfile[indexPath.row]
    
    if indexPath.row == 0 || indexPath.row == 2 {
      profilecontentCell.accessoryType = .disclosureIndicator
    } else if indexPath.row == 1 {
      let image = #imageLiteral(resourceName: "check")
      let imageView = UIImageView(image: image)
      profilecontentCell.accessoryView = imageView
    } else {
      let accessTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
      accessTitleLabel.text = "CLASSIC"
      accessTitleLabel.fontSize = 14
      accessTitleLabel.textColor = UIColor.rgbColor(red: 206, green: 32, blue: 36)
      accessTitleLabel.textAlignment = .right
      profilecontentCell.accessoryView = accessTitleLabel
    }
    
    return profilecontentCell
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let footer = tableView.dequeueReusableCell(withIdentifier: "FooterTransferTableViewCell") as? FooterTransferTableViewCell else { return UIView() }
    return footer
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UIDevice.isPhone5SE ? 40 : 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = .none
    if indexPath.row == 0 {
      let accountDetailController = SwinjectStoryboard.initController(withIdentifier: ControllerName.accountDetailViewController.rawValue, fromStoryboard: StoryboardName.profile.rawValue)
      navigationController?.pushViewController(accountDetailController, animated: true)
    } else if indexPath.row == 2 {
      let manageRecipientController = SwinjectStoryboard.initController(withIdentifier: ControllerName.manageRecipientsController.rawValue, fromStoryboard: StoryboardName.profile.rawValue)
      navigationController?.pushViewController(manageRecipientController, animated: true)
    }
  }
}

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
   logoImageView.image = image
   let resizeImage = image.crop(toWidth: 50.0, toHeight: 50.0)
    
    guard let imageData:Data = resizeImage!.jpegData(compressionQuality: 0.5) else {return}
     let base64String = imageData.base64EncodedString()
    
    guard let handle = UserDefaults.value(forKey: .handle) else { return }
    
    let document: Document = Document(type: .Other, name: "photo" + ".jpg", mime: "image/jpeg", data: base64String, gZip: false)
    
    documents = [Document]()
    documents.append(document)
    

    //MARK: Prepare Model or Parameter for upload image
    uploadingAvatar = UploadingAvatarViewModel(avatar: true, deviceId: UIDevice.deviceId, documents: documents, lang: "EN", handle: handle, timeStamp: Date.javisDateFormat)

    //Upload avatar to server
    apiUpload.uploadAvatar(imageData: imageData, parameter: uploadingAvatar.parameters, completion: { (response ,error) in
      if let response = response?.files?.values{
        print(response)
      }
    })
    
      picker.dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
