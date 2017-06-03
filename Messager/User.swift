//
//  User.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class User {
  let uid: String
  let name: String
  let email: String
  let profilePictureUrl: String
  
  init(uid: String, name: String, email: String, profilePictureUrl: String) {
    self.uid = uid
    self.name = name
    self.email = email
    self.profilePictureUrl = profilePictureUrl
  }
}
