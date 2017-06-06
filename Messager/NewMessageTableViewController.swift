//
//  NewMessageTableViewController.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
  weak var delegate: PresentChatLogDelegate?
  
  var users = [User]()
  
  let cellId = "cellId"

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
    
    self.tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: cellId)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    fetchUsers()
  }
  
  func handleCancel() {
    self.dismiss(animated: true) { 
      // may do smth
    }
  }
  
  func fetchUsers() {
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      guard var userDictionary = snapshot.value as? [String: Any] else { return }
      userDictionary["uid"] = snapshot.key
      let user = User(with: userDictionary)
      self.users.append(user)
      
      DispatchQueue.main.async {
        // If call this without async, the app will crash due to background thread
        self.tableView.reloadData()
      }
      
    }) { (error) in
      print(error)
    }
  }
  
}

extension NewMessageTableViewController {
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewMessageTableViewCell
    cell?.user = users[indexPath.row]
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // TODO: dismiss, call delegate's present ChatLog and pass user info
    dismiss(animated: true) { 
      self.delegate?.presentChatLog(of: self.users[indexPath.row])
    }
  }
  
}
