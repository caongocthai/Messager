//
//  MessagesTableViewCell.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {
  var timer: Timer?
  
  var message: Message? {
    didSet {
      guard let message = message else { return }
      let partnerId = message.getPartnerId()
      loadPartnerNameAndPicture(with: partnerId)
    }
  }
  
  var partner: User?
  
  func loadPartnerNameAndPicture(with partnerId: String) {
    let partnerRef = Database.database().reference().child("users").child(partnerId)
    partnerRef.observe(.value, with: { (snapshot) in
      guard var userDictionary = snapshot.value as? [String: Any] else { return }
      userDictionary["uid"] = partnerId
      self.partner = User(with: userDictionary)

      guard
        let name = userDictionary["name"] as? String,
        let profilePictureUrl = userDictionary["profilePictureUrl"] as? String,
        let seconds = self.message?.timestamp.doubleValue
        else { return }
      
      self.nameLabel.text = name
      self.messageLabel.text = self.message?.text ?? "Sent an image..."  // Set here so they are all set at the same time

      let messageDate = Date(timeIntervalSince1970: seconds)
      let currentSeconds = Date().timeIntervalSince1970
      let timeInterval = currentSeconds - seconds
      let timeLabelText = messageDate.getTimeString(with: timeInterval)
      self.timeLabel.text = timeLabelText
      
      let estimatedTimeLabelWidth = timeLabelText.estimateFrameFor(size: CGSize(width: 1000, height: 42-18), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)]).width
      self.timeLabelConstraints[2].constant = -estimatedTimeLabelWidth - 16 - 2
      
      self.profilePictureImageView.loadImageUsingCache(with: profilePictureUrl)
    })
  }
  
  let profilePictureImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = UIColor(r: 240, g: 240, b: 240, a: 1)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 24
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
    label.textColor = .darkGray
    return label
  }()
  
  let timeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
    label.textColor = .gray
    label.textAlignment = .right
    return label
  }()
  var timeLabelConstraints = [NSLayoutConstraint]()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
//    timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
    
    addProfilePictureImageView()
    addLabels()
    addTimeLabel()
  }
  
//  Temporary remove this function
//  func updateTimeDisplay() {
//    guard let seconds = self.message?.timestamp.doubleValue else { return }
//    let currentSeconds = Date().timeIntervalSince1970
//    let timeInterval = currentSeconds - seconds
//    timeLabel.text = timeInterval.getTimeString()
//    
//    if timer != nil {
//      timer?.invalidate()
//      if timeInterval < 60 {
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else if timeInterval < 60*60 {
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else if timeInterval < 60*60*24 {
//        timer = Timer.scheduledTimer(timeInterval: 60*60, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else if timeInterval < 60*60*24*7 {
//        timer = Timer.scheduledTimer(timeInterval: 60*60*24, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else if timeInterval < 60*60*24*30 {
//        timer = Timer.scheduledTimer(timeInterval: 60*60*24*7, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else if timeInterval < 60*60*24*365.25 {
//        timer = Timer.scheduledTimer(timeInterval: 60*60*24*30, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      } else {
//        timer = Timer.scheduledTimer(timeInterval: 60*60*24*365.25, target: self, selector: #selector(self.updateTimeDisplay), userInfo: nil, repeats: true)
//      }
//    }
//  }

//  override func willRemoveSubview(_ subview: UIView) {
//    super.willRemoveSubview(subview)
//    
//    timer?.invalidate()
//  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addProfilePictureImageView() {
    self.addSubview(profilePictureImageView)
    
    _ = profilePictureImageView.constraintCenterTo(centerX: nil, xConstant: nil, centerY: self.centerYAnchor, yConstant: 0)
    _ = profilePictureImageView.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: self.leftAnchor, leftConstant: 16, right: nil, rightConstant: nil)
    _ = profilePictureImageView.constraintSizeToConstant(widthConstant: 48, heightConstant: 48)
  }
  
  func addLabels() {
    self.addSubview(nameLabel)
    self.addSubview(messageLabel)
    
    _ = nameLabel.constraintAnchorTo(top: self.topAnchor, topConstant: 18, bottom: self.topAnchor, bottomConstant: 42, left: profilePictureImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: 0)
    _ = messageLabel.constraintAnchorTo(top: nameLabel.bottomAnchor, topConstant: 0, bottom: self.bottomAnchor, bottomConstant: -18, left: profilePictureImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: 0)
  }
  
  func addTimeLabel() {
    self.addSubview(timeLabel)
    
    timeLabelConstraints = timeLabel.constraintAnchorTo(top: nameLabel.topAnchor, topConstant: 0, bottom: nameLabel.bottomAnchor, bottomConstant: 0, left: self.rightAnchor, leftConstant: -100, right: self.rightAnchor, rightConstant: -16)
  }
}

