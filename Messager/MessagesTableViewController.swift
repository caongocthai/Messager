//
//  ViewController.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

var currentUserUid: String!

class MessagesTableViewController: UITableViewController {
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = UIView()
    
    getUserOrLogout()
    setUpNavigationBar()
  }
  
  func setUpNavigationBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
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
    currentUserUid = uid
    
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapShot) in
      guard let userDictionary = snapShot.value as? [String: Any] else { return }
      self.navigationItem.title = userDictionary["name"] as? String
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
    
    let loginViewController = LoginViewController()
    loginViewController.delegate = self
    self.present(loginViewController, animated: true) { 
      // may do smth later
    }
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
    self.navigationItem.title = title
  }
  
  func setNavigationTitleByAccessingDatabase() {
    getUserInfoFromDatabase()
  }
}

extension MessagesTableViewController: PresentChatLogDelegate {
  func presentChatLog(of partner: User) {
    let layout = UICollectionViewFlowLayout()
    let chatLogCollectionViewController = ChatLogCollectionViewController(collectionViewLayout: layout)
    let chatLogNavigationController = UINavigationController(rootViewController: chatLogCollectionViewController)
    present(chatLogNavigationController, animated: true) { 
      // may do smth later
    }
  }
}
