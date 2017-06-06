//
//  ChatLogController+imagePicker.swift
//  Messager
//
//  Created by Harry Cao on 4/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

extension ChatLogCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func handleUploadImage() {
    let imagePicker = UIImagePickerController()
    imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
    imagePicker.delegate = self
//    imagePicker.allowsEditing = true
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
    if let url = info[UIImagePickerControllerMediaURL] as? URL {
      uploadVideoToStorage(with: url)
    } else {
      uploadImageToStorage(with: info)
    }
    
    dismiss(animated: true) {
      // may do smth
    }
  }
  
  fileprivate func uploadVideoToStorage(with url: URL) {
    let imageName = NSUUID().uuidString
    let storageRef = Storage.storage().reference().child("message_videos").child("\(imageName).mov")
    
    // Upload the video to Storage
    let uploadTask = storageRef.putFile(from: url, metadata: nil) { (metadata, error) in
      if let error = error {
        print(error)
        return
      }
      
      // Successfully save video to storage
      // TODO: Send a image capture of the video to storage and display that image in massages
      guard
        let videoUrl = metadata?.downloadURL()?.absoluteString,
        let thumbnailImage = self.thumbnailImageForFileUrl(url)
      else { return }
      
      // Send the thumbnailImage to storage and send message contains the imageUrl to database
      self.uploadMessageImageToStorage(with: thumbnailImage, completion: { (imageUrl) in
        let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl]
        self.sendMessageToDatabase(with: properties)
      })
    }
    
    //TODO: Observe state of uploadTask
    
    uploadTask.observe(.progress) { (snapshot) in
      guard let fraction = snapshot.progress?.fractionCompleted else { return }
      
      let mul = CGFloat(fraction*0.7)
      let containerWidth = self.inputContainerView.frame.width
      
      self.uploadingProgressLine.frame = CGRect(x: self.inputContainerView.frame.origin.x, y: self.inputContainerView.frame.origin.y, width: mul*containerWidth, height: 5)
    }
    
    uploadTask.observe(.success) { (snapshot) in
      Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
        self.uploadingProgressLine.frame = CGRect(x: self.inputContainerView.frame.origin.x, y: self.inputContainerView.frame.origin.y, width: self.inputContainerView.frame.width*0.8, height: 5)
        timer.invalidate()
      })
      
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
        self.uploadingProgressLine.frame = CGRect(x: self.inputContainerView.frame.origin.x, y: self.inputContainerView.frame.origin.y, width: self.inputContainerView.frame.width*0.9, height: 5)
        timer.invalidate()
      })
      
      Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
        self.uploadingProgressLine.frame = .zero
        timer.invalidate()
      })
    }
    
    uploadTask.observe(.failure) { (snapshot) in
      // do something if fail
    }
  }
  
  fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
    let asset = AVAsset(url: fileUrl)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    
    do {
      
      let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
      return UIImage(cgImage: thumbnailCGImage)
      
    } catch let err {
      print(err)
    }
    
    return nil
  }
  
  fileprivate func uploadImageToStorage(with info: [String: Any]) {
    var selectedImage: UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImage = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImage = originalImage
    }
    
    // Send the image to storage and send message contains the imageUrl to database
    uploadMessageImageToStorage(with: selectedImage!) { (imageUrl) in
      let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": selectedImage!.size.width, "imageHeight": selectedImage!.size.height]
      self.sendMessageToDatabase(with: properties)
    }
  }
  
  fileprivate func uploadMessageImageToStorage(with image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
    let imageName = NSUUID().uuidString
    let storageRef = Storage.storage().reference().child("message_images").child("\(imageName).jpeg")
    
    // upload image in compressed size
    guard  let uploadData = UIImageJPEGRepresentation(image, 0.2) else { return }
    
    //upload image in full quality size
    //    guard let uploadData = UIImagePNGRepresentation(self.profilePictureImageView.image!) else { return }
    
    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
      if let error = error {
        print(error)
        return
      }
      
      // Successfully save picture to storage
      guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
      completion(imageUrl)
    }
  }
}
