//
//  ChatLogCollectionViewController.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ChatLogCollectionViewController: UICollectionViewController {
  let cellId = "cellId"
  
  var partner: User? {
    didSet {
      guard let partner = partner else { return }
      self.navigationItem.title = partner.name
      
      self.observeMessagesUpdated()
    }
  }
  
  let inputContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .white
    return containerView
  }()
  
  let inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter messages..."
    return textField
  }()
  
  lazy var sendButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Send", for: .normal)
    button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    return button
  }()
  
  let inputSeparatorLine: UIView = {
    let separatorLine = UIView()
    separatorLine.backgroundColor = .lightGray
    return separatorLine
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView?.backgroundColor = .white
    self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    addInputView()
  }
  
  func addInputView() {
    self.collectionView?.addSubview(inputContainerView)
    inputContainerView.addSubview(sendButton)
    inputContainerView.addSubview(inputTextField)
    inputContainerView.addSubview(inputSeparatorLine)
    
    _ = inputContainerView.constraintAnchorTo(top: self.view.bottomAnchor, topConstant: -50, bottom: self.view.bottomAnchor, bottomConstant: 0, left: self.view.leftAnchor, leftConstant: 0, right: self.view.rightAnchor, rightConstant: 0)
    
    _ = sendButton.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: inputContainerView.rightAnchor, leftConstant: -48, right: inputContainerView.rightAnchor, rightConstant: -8)
    
    _ = inputTextField.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: inputContainerView.leftAnchor, leftConstant: 8, right: sendButton.leftAnchor, rightConstant: -8)
    
    _ = inputSeparatorLine.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.topAnchor, bottomConstant: 1, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
  }
}

extension ChatLogCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let messageCell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatMessageCollectionViewCell
    messageCell?.messageTextView.text = "Hello, World!!!!"
    return messageCell!
  }
}

extension ChatLogCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width, height: 60)
  }
}

