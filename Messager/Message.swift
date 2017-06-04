//
//  Message.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import Firebase

class Message {
  let fromId: String
  let toId: String
  let timestamp: NSNumber
  
  var text: String?
  
  var imageUrl: String?
  var imageWidth: NSNumber?
  var imageHeight: NSNumber?
  
  init(with dictionary: [String: Any]) {
    self.fromId = dictionary["fromId"] as! String
    self.toId = dictionary["toId"] as! String
    self.timestamp = dictionary["timestamp"] as! NSNumber
    
    self.text = dictionary["text"] as? String
    
    self.imageUrl = dictionary["imageUrl"] as? String
    self.imageWidth = dictionary["imageWidth"] as? NSNumber
    self.imageHeight = dictionary["imageHeight"] as? NSNumber
  }
  
  func getPartnerId() -> String {
    return Auth.auth().currentUser?.uid == fromId ? toId : fromId
  }
}
