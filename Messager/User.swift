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
  
  init(with dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as! String
    self.name = dictionary["name"] as! String
    self.email = dictionary["email"] as! String
    self.profilePictureUrl = dictionary["profilePictureUrl"] as! String
  }
}
