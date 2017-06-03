//
//  ChatLogController+send.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import Firebase

extension ChatLogCollectionViewController {
  
  
  func handleSend() {
    guard let text = inputTextField.text else { return }
    if text == "" { return }
    
    let ref = Database.database().reference().child("messages")
    let messageRef = ref.childByAutoId()
    guard
      let fromId = currentUserUid,
      let toId = partner?.uid
    else { return }
    let timestamp: NSNumber = Int(Date().timeIntervalSince1970) as NSNumber
    let values = ["fromId": fromId, "toId": toId, "text": text, "timestamp": timestamp] as [String : Any]
    
    
    messageRef.updateChildValues(values) { (error, databaseRef) in
      if let error = error {
        print(error)
        return
      }
      
      self.inputTextField.text = nil
      
      let messageId = messageRef.key
      let userMessageRef = Database.database().reference().child("user_messages").child(fromId).child(toId)
      let partnerMessageRef = Database.database().reference().child("user_messages").child(toId).child(fromId)
      
      userMessageRef.updateChildValues([messageId: 1])
      partnerMessageRef.updateChildValues([messageId: 1])
    }
  }
}