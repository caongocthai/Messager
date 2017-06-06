//
//  ChatMessageCell+zoomImage+playVideo.swift
//  Messager
//
//  Created by Harry Cao on 6/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import AVFoundation

extension ChatMessageCollectionViewCell {
  func handleZoomTap() {
    if videoUrl != nil { return }
    self.delegate?.performZoomInFor(messageImageView)
  }
  
  func handlePlay() {
    guard
      let videoUrl = videoUrl,
      let url = URL(string: videoUrl)
      else { return }
    
    
    // This is for playing fedault AVPlayer
    self.delegate?.playVideoFor(url: url)
 
    
    /*
    // This is for custom player
    videoPlayer = AVPlayer(url: url)
    videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
    videoPlayerLayer?.frame = bubbleView.bounds
    bubbleView.layer.addSublayer(videoPlayerLayer!)
    
    activityIndicatorView.startAnimating()
    playButton.isHidden = true
    videoPlayer?.play()*/
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    playButton.removeFromSuperview()
    messageImageView.removeFromSuperview()
    videoUrl = nil
    
    /*
    // This is for custom player
    videoPlayerLayer?.removeFromSuperlayer()
    videoPlayer?.pause()
    activityIndicatorView.stopAnimating()*/
  }
}
