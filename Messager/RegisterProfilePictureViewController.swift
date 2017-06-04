//
//  RegisterProfilePictureViewController.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class RegisterProfilePictureViewController: UIViewController {
  var values: [String: Any]!
  
  let screenTitle: UILabel = {
    let label = UILabel()
    label.text = "Profile picture"
    label.textColor = .darkRed
    label.textAlignment = .center
    label.font = UIFont.init(name: "Chalkduster", size: 24)
    return label
  }()
  
  let profilePictureImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "avatar-default")
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 120
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let buttonsContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .darkYellow
    containerView.layer.cornerRadius = 8
    containerView.clipsToBounds = true
    return containerView
  }()
  
  lazy var importButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Choose image", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
    button.setTitleColor(.darkYellow, for: .normal)
    button.backgroundColor = .white
    button.layer.borderColor = UIColor.darkYellow.cgColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(handleImport), for: .touchUpInside)
    return button
  }()
  
  lazy var proceedButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Use this picture", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .darkYellow
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(handleProceed), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = .white
    
    addProfilePictureImageView()
    addScreenTitle()
    addButtons()
  }
  
  func addProfilePictureImageView() {
    self.view.addSubview(profilePictureImageView)
    
    _ = profilePictureImageView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: self.view.centerYAnchor, yConstant: -20)
    _ = profilePictureImageView.constraintSizeToConstant(widthConstant: 240, heightConstant: 240)
  }
  
  func addScreenTitle() {
    self.view.addSubview(screenTitle)
    _ = screenTitle.constraintAnchorTo(top: nil, topConstant: nil, bottom: profilePictureImageView.topAnchor, bottomConstant: -80, left: self.view.leftAnchor, leftConstant: 0, right: self.view.rightAnchor, rightConstant: 0)
    _ = screenTitle.constraintSizeToConstant(widthConstant: nil, heightConstant: 50)
  }
  
  func addButtons() {
    self.view.addSubview(buttonsContainerView)
    buttonsContainerView.addSubview(importButton)
    buttonsContainerView.addSubview(proceedButton)
    
    _ = buttonsContainerView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: nil, yConstant: nil)
    _ = buttonsContainerView.constraintAnchorTo(top: profilePictureImageView.bottomAnchor, topConstant: 80, bottom: nil, bottomConstant: nil, left: nil, leftConstant: nil, right: nil, rightConstant: nil)
    _ = buttonsContainerView.constraintSizeToConstant(widthConstant: 300, heightConstant: 50)
    
    _ = importButton.constraintAnchorTo(top: buttonsContainerView.topAnchor, topConstant: 0, bottom: buttonsContainerView.bottomAnchor, bottomConstant: 0, left: buttonsContainerView.leftAnchor, leftConstant: 0, right: buttonsContainerView.centerXAnchor, rightConstant: -1)
    
    _ = proceedButton.constraintAnchorTo(top: buttonsContainerView.topAnchor, topConstant: 0, bottom: buttonsContainerView.bottomAnchor, bottomConstant: 0, left: buttonsContainerView.centerXAnchor, leftConstant: 1, right: buttonsContainerView.rightAnchor, rightConstant: 0)
  }
}


extension RegisterProfilePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func handleImport() {
    // TODO: present picker, set profileImageView's image after
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true) { 
      // may do smth
    }
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) { 
      // may do smth
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImage: UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImage = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImage = originalImage
    }
    profilePictureImageView.image = selectedImage
    
    dismiss(animated: true) { 
      // may do smth
    }
  }
}

extension RegisterProfilePictureViewController {
  func handleProceed() {
    let profilePictureName = NSUUID().uuidString
    let storageRef = Storage.storage().reference().child("profile_pictures").child("\(profilePictureName).jpeg")
    
    // upload image in compressed size
    guard let profilePicture = self.profilePictureImageView.image,
      let uploadData = UIImageJPEGRepresentation(profilePicture, 0.05) else { return }
    
    //upload image in full quality size
//    guard let uploadData = UIImagePNGRepresentation(self.profilePictureImageView.image!) else { return }
    
    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
      if let error = error {
        print(error)
        return
      }
      
      // Successfully save picture to staorage
      guard
        let uid = Auth.auth().currentUser?.uid,
        let profilePictureUrl = metadata?.downloadURL()?.absoluteString
      else { return }
      self.values?["profilePictureUrl"] = profilePictureUrl
      
      let userRef  = Database.database().reference().child("users").child(uid)
      userRef.updateChildValues(self.values, withCompletionBlock: { (err, dataRef) in
        if let err = err {
          print(err)
          return
        }
        self.dismiss(animated: true, completion: { 
          // may do smth
        })
      })
    }
  }
}
