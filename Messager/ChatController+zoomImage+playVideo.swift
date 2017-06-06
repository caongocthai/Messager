//
//  ChatController+zoomImage+playVideo.swift
//  Messager
//
//  Created by Harry Cao on 5/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

extension ChatLogCollectionViewController: ZoomImageAndPlayVideoDelegate {
  func performZoomInFor(_ startingImageView: UIImageView) {
    // Hide keyboard
    inputTextField.resignFirstResponder()
    
    guard
      let startingImageViewFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil),
      let keyWindow = UIApplication.shared.keyWindow
    else { return }
    
    self.startingImageView = startingImageView
    self.startingImageView?.isHidden = true
    self.startingImageViewFrame = startingImageViewFrame
    
    let zoomingImageView = UIImageView(frame: startingImageViewFrame)
    zoomingImageView.image = startingImageView.image
    zoomingImageView.isUserInteractionEnabled = true
    let zoomOutGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleZoomOut))
    zoomingImageView.addGestureRecognizer(zoomOutGesture)
    
//    self.blackBackgroundView.frame = keyWindow.frame
    
    keyWindow.addSubview(self.blackBackgroundView)
    keyWindow.addSubview(zoomingImageView)
    
    _ = self.blackBackgroundView.constraintAnchorTo(top: keyWindow.topAnchor, topConstant: 0, bottom: keyWindow.bottomAnchor, bottomConstant: 0, left: keyWindow.leftAnchor, leftConstant: 0, right: keyWindow.rightAnchor, rightConstant: 0)
    
    let zoomedHeight = startingImageViewFrame.height / startingImageViewFrame.width * keyWindow.frame.width
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
      self.blackBackgroundView.alpha = 1
      self.inputContainerView.alpha = 0
      
      zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: zoomedHeight)
      zoomingImageView.center = keyWindow.center
    }) { (completed) in
      // may do smth
    }
  }
  
  func handleZoomOut(_ pinchGesture: UIPinchGestureRecognizer) {
    guard
      let zoomOutImageView = pinchGesture.view,
      let startingImageViewFrame = self.startingImageViewFrame
    else { return }
    
    if pinchGesture.state == .ended {
      zoomOutImageView.layer.cornerRadius = 14
      zoomOutImageView.clipsToBounds = true
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        zoomOutImageView.frame = startingImageViewFrame
        self.blackBackgroundView.alpha = 0
        self.inputContainerView.alpha = 1
      }) { (completed) in
        zoomOutImageView.removeFromSuperview()
        self.startingImageView?.isHidden = false
      }
    }
  }
  
  
  func playVideoFor(url: URL) {
    let videoPlayer = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = videoPlayer
    present(playerViewController, animated: true) { 
      // may do smth
      videoPlayer.play()
    }
  }
}
