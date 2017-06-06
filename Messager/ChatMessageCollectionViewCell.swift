//
//  ChatMessageCollectionViewCell.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCollectionViewCell: UICollectionViewCell {
  weak var delegate: ZoomImageAndPlayVideoDelegate?
  
  var isSent: Bool? {
    didSet {
      guard let isSent = isSent else { return }
      if isSent {
        bubbleView.backgroundColor = .darkYellow
        messageTextView.textColor = .darkRed
        partnerProfileImageView.isHidden = true
        bubbleViewConstraints[3].isActive = false
        bubbleViewConstraints[4].isActive = true
      } else {
        bubbleView.backgroundColor = .veryLightGray
        messageTextView.textColor = .black
        partnerProfileImageView.isHidden = false
        bubbleViewConstraints[3].isActive = true
        bubbleViewConstraints[4].isActive = false
      }
    }
  }
  
  var messageText: String? {
    didSet {
      guard let messageText = messageText else { return }
      self.messageTextView.isHidden = false
      self.messageImageView.isHidden = true
      messageTextView.text = messageText
      self.addMessageTextView()
    }
  }
  
  var partnerProfilePictureUrl: String?  {
    didSet {
      guard let partnerProfilePictureUrl = partnerProfilePictureUrl else { return }
      partnerProfileImageView.loadImageUsingCache(with: partnerProfilePictureUrl)
    }
  }
  
  var bubbleEstimatedWidth: CGFloat? {
    didSet {
      guard let bubbleEstimatedWidth = bubbleEstimatedWidth else { return }
      bubbleViewConstraints[0].constant = bubbleEstimatedWidth
    }
  }
  
  var imageUrl: String? {
    didSet {
      guard let imageUrl = imageUrl else { return }
      self.messageTextView.isHidden = true
      self.messageImageView.isHidden = false
      self.bubbleView.backgroundColor = .clear
      self.messageImageView.loadImageUsingCache(with: imageUrl)
      self.addMessageImageView()
    }
  }
  
  var videoUrl: String? {
    didSet {
      if videoUrl == nil { return }
      addPlayButton()
      /*
       // This is for display loading when loading video
      addActivityIndicatorView()*/
    }
  }
  
  /*
  // Need these 2 properties for custom video player
  var videoPlayer: AVPlayer?
  var videoPlayerLayer: AVPlayerLayer?
  
  let activityIndicatorView: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    aiv.hidesWhenStopped = true
    return aiv
  }()
  */
  
  let bubbleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 14
    view.clipsToBounds = true
    view.backgroundColor = .clear
    return view
  }()
  var bubbleViewConstraints = [NSLayoutConstraint]()
  
  let messageTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
    textView.isEditable = false
    textView.backgroundColor = .clear
    return textView
  }()
  
  let partnerProfileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 16
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var messageImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  lazy var playButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    button.tintColor = .lightGray
    button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addComponents()
  }
  
  func addComponents() {
    self.addSubview(bubbleView)
    self.addSubview(partnerProfileImageView)
    
    
    bubbleViewConstraints = bubbleView.constraintSizeToConstant(widthConstant: 200, heightConstant: nil)
    bubbleViewConstraints.append(contentsOf: bubbleView.constraintAnchorTo(top: self.topAnchor, topConstant: 0, bottom: self.bottomAnchor, bottomConstant: 0, left: partnerProfileImageView.rightAnchor, leftConstant: 8, right: self.rightAnchor, rightConstant: -8))
    
    _ = partnerProfileImageView.constraintAnchorTo(top: self.bottomAnchor, topConstant: -32, bottom: self.bottomAnchor, bottomConstant: 0, left: self.leftAnchor, leftConstant: 8, right: self.leftAnchor, rightConstant: 40)
  }
  
  func addMessageTextView() {
    bubbleView.addSubview(messageTextView)
    _ = messageTextView.constraintAnchorTo(top: bubbleView.topAnchor, topConstant: 0, bottom: bubbleView.bottomAnchor, bottomConstant: 0, left: bubbleView.leftAnchor, leftConstant: 8, right: bubbleView.rightAnchor, rightConstant: -4)
  }
  
  func addMessageImageView() {
    bubbleView.addSubview(messageImageView)
    _ = messageImageView.constraintAnchorTo(top: bubbleView.topAnchor, topConstant: 0, bottom: bubbleView.bottomAnchor, bottomConstant: 0, left: bubbleView.leftAnchor, leftConstant: 0, right: bubbleView.rightAnchor, rightConstant: 0)
  }
  
  func addPlayButton() {
    bubbleView.addSubview(playButton)
    _ = playButton.constraintCenterTo(centerX: bubbleView.centerXAnchor, xConstant: 0, centerY: bubbleView.centerYAnchor, yConstant: 0)
    _ = playButton.constraintSizeToConstant(widthConstant: 50, heightConstant: 50)
  }
  
  /*
  func addActivityIndicatorView() {
    bubbleView.addSubview(activityIndicatorView)
    _ = activityIndicatorView.constraintCenterTo(centerX: bubbleView.centerXAnchor, xConstant: 0, centerY: bubbleView.centerYAnchor, yConstant: 0)
    _ = activityIndicatorView.constraintSizeToConstant(widthConstant: 50, heightConstant: 50)
  }
 */
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
