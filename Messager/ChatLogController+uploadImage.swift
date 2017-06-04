//
//  ChatLogController+imagePicker.swift
//  Messager
//
//  Created by Harry Cao on 4/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

extension ChatLogCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func handleUploadImage() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    present(imagePicker, animated: true) { 
      // may do smth
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true) { 
      //may do smth
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImage: UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImage = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImage = originalImage
    }
//    profilePictureImageView.image = selectedImage
//    print(selectedImage.width)
    
    dismiss(animated: true) {
      // may do smth
    }
  }
}
