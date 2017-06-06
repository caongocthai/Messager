//
//  MessagesTalbeController+delete.swift
//  Messager
//
//  Created by Harry Cao on 5/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

extension MessagesTableViewController {
  func setupForDeleteableRow() {
    self.tableView.allowsMultipleSelectionDuringEditing = true
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    let partnerId = self.newestMessages[indexPath.row].getPartnerId()
    
    let partnertMessagesRef = Database.database().reference().child("user_messages").child(uid).child(partnerId)
    partnertMessagesRef.removeValue { (error, ref) in
      if let error = error {
        print(error)
        return
      }
      
      self.newestMessagesDictionary.removeValue(forKey: partnerId)
      self.asyncReloadTable()
    }
  }
}
