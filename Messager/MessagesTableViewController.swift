//
//  ViewController.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
  let cellId = "cellId"
  var user: User!
  var newestMessages = [Message]()
  var newestMessagesDictionary = [String: Message]()
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = UIView()
    self.tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: cellId)
    
    getUserOrLogout()
    setUpNavigationBar()
    observeUserMessages()
  }
  
  func setUpNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
  }

  func getUserOrLogout() {
    guard let _ = Auth.auth().currentUser?.uid else {
      perform(#selector(handleLogout), with: nil, afterDelay: 0.01)
      return
    }
    
    getUserInfoFromDatabase()
  }
  
  func getUserInfoFromDatabase() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
      guard
        let userDictionary = snapShot.value as? [String: Any],
        let title = userDictionary["name"] as? String
      else { return }
      self.setNavigationTitle(with: title)
    }) { (error) in
      print(error)
    }
  }
  
  func handleNewMessage() {
    let newMessageTableViewController = NewMessageTableViewController()
    newMessageTableViewController.delegate = self
    let newMessagesNavVC = UINavigationController(rootViewController: newMessageTableViewController)
    present(newMessagesNavVC, animated: true) { 
      // may do smth
    }
  }
  
  func handleLogout() {
    do {
      try Auth.auth().signOut()
    } catch let err {
      print(err)
    }
    
    self.newestMessages.removeAll()
    self.newestMessagesDictionary.removeAll()
    self.tableView.reloadData()
    
    let loginViewController = LoginViewController()
    loginViewController.delegate = self
    self.present(loginViewController, animated: true) {
      // may do smth
    }
  }
}

extension MessagesTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newestMessages.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesTableViewCell
    cell.message = newestMessages[indexPath.row]
    
    // We do this, because let say there is a new message. The doesn't get replace. Just the content in the row get replaced.
    // There for. Let say:
    //   1. Row 3 has a message 35m ago, so it refrash timer every 1m
    //   2. Row 4 has a message 8h ago, so refresh every 1h
    //  Now. We receive or send a message with person at row 6, the concent then fo up to row 1. Push every row from 1-5 down 1 row.
    //    Therefore, row (previous row 3) get refresh every 1h instead of 1m (inherit this behaviour from previous row 4)
    // So, we need to manually refresh timer in every row everytime we reloaded data.
//    cell.updateTimeDisplay()
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
      let selectedCell = self.tableView.cellForRow(at: indexPath) as? MessagesTableViewCell,
      let partner = selectedCell.partner
    else { return }
    presentChatLog(of: partner)
  }
}

extension MessagesTableViewController: SetNavTitleAndPresentProfilePicturePickerDelegate {
  func presentProfilePicturePicker(with values: [String: Any]) {
    let registerProfilePictureViewController = RegisterProfilePictureViewController()
    registerProfilePictureViewController.values = values
    present(registerProfilePictureViewController, animated: true) { 
      //may do smth
    }
  }
  
  func setNavigationTitle(with title: String) {
    // Set titleView instead of title, so pushVC will have backbutton's title = "Back"
    let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    titleView.text = title
    self.navigationItem.titleView = titleView
      
    
    // Also, just register a user and have their uid, now observe their messages
    observeUserMessages()
  }
  
  func setNavigationTitleByAccessingDatabase() {
    getUserInfoFromDatabase()
  }
}

extension MessagesTableViewController: PresentChatLogDelegate {
  func presentChatLog(of partner: User) {
    let layout = UICollectionViewFlowLayout()
    let chatLogCollectionViewController = ChatLogCollectionViewController(collectionViewLayout: layout)
    chatLogCollectionViewController.partner = partner
    
    self.navigationController?.pushViewController(chatLogCollectionViewController, animated: true)
  }
}
