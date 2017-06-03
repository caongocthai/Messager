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
    guard let partnerId = partner?.uid else { return }
    
    let chatLogRef = Database.database().reference().child("user_messages").child(currentUserUid).child(partnerId)
    chatLogRef.observe(.childAdded, with: { (snapshot) in
      let messageId = snapshot.key
      
      
    })
  }
}
