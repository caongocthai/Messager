//
//  NewMessageTableViewCell.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
  var user: User? {
    didSet {
      guard let user = user else { return }
      nameLabel.text = user.name
      profilePictureImageView.loadImageUsingCache(with: user.profilePictureUrl)
    }
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
    let nameLabel = UILabel()
    return nameLabel
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addProfilePictureImageView()
    addNameView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addProfilePictureImageView() {
    self.addSubview(profilePictureImageView)
    
    _ = profilePictureImageView.constraintCenterTo(centerX: nil, xConstant: nil, centerY: self.centerYAnchor, yConstant: 0)
    _ = profilePictureImageView.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: self.leftAnchor, leftConstant: 16, right: nil, rightConstant: nil)
    _ = profilePictureImageView.constraintSizeToConstant(widthConstant: 48, heightConstant: 48)
  }
  
  func addNameView() {
    self.addSubview(nameLabel)
    
    _ = nameLabel.constraintAnchorTo(top: self.topAnchor, topConstant: 0, bottom: self.bottomAnchor, bottomConstant: 0, left: profilePictureImageView.rightAnchor, leftConstant: 12, right: self.rightAnchor, rightConstant: 0)
  }
}
