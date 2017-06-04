//
//  ChatMessageCollectionViewCell.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
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
  
  let bubbleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    return view
  }()
  var bubbleViewConstraints = [NSLayoutConstraint]()
  
  let messageTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
