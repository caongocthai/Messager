//
//  Message.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

class Message {
  let fromId: String
  let toId: String
  let text: String
  let timestamp: NSNumber
  
  init(fromId: String, toId: String, text: String, timestamp: NSNumber) {
    self.fromId = fromId
    self.toId = toId
    self.text = text
    self.timestamp = timestamp
  }
}
