//
//  ChatLogController+observeMessagesUpdated.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import Firebase

extension ChatLogCollectionViewController {
  func observeMessagesUpdated() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let partnerId = partner?.uid else { return }
    
    let chatLogRef = Database.database().reference().child("user_messages").child(uid).child(partnerId)
    chatLogRef.observe(.childAdded, with: { (snapshot) in
      let messageId = snapshot.key
      
      let messageRef = Database.database().reference().child("messages").child(messageId)
      messageRef.observe(.value, with: { (snapshot) in
        guard let messageDictionary = snapshot.value as? [String: Any] else { return }
        let message = Message(with: messageDictionary)
        self.messages.append(message)
        
        DispatchQueue.main.async {
          self.collectionView?.reloadData()
        }
      })
      
    })
  }
}
