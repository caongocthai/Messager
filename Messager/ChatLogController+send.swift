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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    handleSend()
    return true
  }
  
  func handleSend() {
    guard let text = inputTextField.text else { return }
    if text == "" { return }
    
    sendMessageToDatabase(with: ["text": text])
  }
  
  func sendMessageToDatabase(with properties: [String: Any]) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let ref = Database.database().reference().child("messages")
    let messageRef = ref.childByAutoId()
    
    guard let toId = partner?.uid else { return }
    let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
    
    var values: [String : Any] = ["fromId": uid, "toId": toId, "timestamp": timestamp]
    properties.forEach({ values[$0] = $1 })
    
    messageRef.updateChildValues(values) { (error, databaseRef) in
      if let error = error {
        print(error)
        return
      }
      
      self.inputTextField.text = nil
      
      let messageId = messageRef.key
      let userMessageRef = Database.database().reference().child("user_messages").child(uid).child(toId)
      let partnerMessageRef = Database.database().reference().child("user_messages").child(toId).child(uid)
      
      userMessageRef.updateChildValues([messageId: 1])
      partnerMessageRef.updateChildValues([messageId: 1])
    }
  }
}
