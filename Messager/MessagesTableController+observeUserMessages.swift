//
//  MessagesTableController+observeUserMessages.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import Firebase

extension MessagesTableViewController {
  func observeUserMessages() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    let userMessageRef = Database.database().reference().child("user_messages").child(uid)
    userMessageRef.observe(.childAdded, with: { (snapshot) in
      let partnerId = snapshot.key
      
      let partnerRef = userMessageRef.child(partnerId)
      partnerRef.observe(.childAdded, with: { (snapshot) in
        let messageId = snapshot.key
        
        self.fetchMessages(with: messageId)
      })
    })
  }
  
  func fetchMessages(with messageId: String) {
    let messageRef = Database.database().reference().child("messages").child(messageId)
    messageRef.observe(.value, with: { (snapshot) in
      guard let messageDictionary = snapshot.value as? [String: Any] else { return }
      //TODO: create a message object, add to the newMesDict as value of key
      //  of the partnerId
      
      let message = Message(with: messageDictionary)
      let partnerId = message.getPartnerId()
      
      // Newer message always get fetched after, so we replace old with newer one. This is because childAutoById give id in chronological way
      self.newestMessagesDictionary[partnerId] = message
      
      // We set a timer and cancel out so the reload never be called. If get called only once at the end.
      //  Why we want to call only once: because, if we call multiple time. The table get reloaded even when the data is not in place (messy). Which cause wrong data in wrong cell.
      // So now, after fetch all message. newMessages and newMessagesDictionary have the right data. We start reload table.
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.asyncReloadTable), userInfo: nil, repeats: false)
    })
  }
  
  func asyncReloadTable() {
    self.newestMessages = Array(self.newestMessagesDictionary.values)
    self.newestMessages.sort{ $0.timestamp.int32Value  >  $1.timestamp.int32Value }

    
    DispatchQueue.main.async(execute: {
      self.tableView.reloadData()
    })
  }
}
