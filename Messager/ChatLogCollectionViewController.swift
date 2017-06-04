//
//  ChatLogCollectionViewController.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class ChatLogCollectionViewController: UICollectionViewController, UITextFieldDelegate {
  let cellId = "cellId"
  
  var partner: User? {
    didSet {
      guard let partner = partner else { return }
      self.navigationItem.title = partner.name
      
      self.observeMessagesUpdated()
    }
  }
  
  var messages = [Message]()
  
  lazy var inputContainerView: UIView = {
    let containerView = UIView()
    containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
    containerView.backgroundColor = .white
    return containerView
  }()
  
  lazy var uploadImageButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "upload_image_icon"), for: .normal)
    button.tintColor = .darkGray
    button.addTarget(self, action: #selector(handleUploadImage), for: .touchUpInside)
    return button
  }()
  
  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter messages..."
    textField.delegate = self
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
    
//    self.navigationController?.navigationBar.backItem?.title = "Back"
    self.navigationItem.backBarButtonItem?.title = "Back"
    
    self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    self.collectionView?.alwaysBounceVertical = true
    self.collectionView?.backgroundColor = .white
    self.collectionView?.showsVerticalScrollIndicator = false
    self.collectionView?.keyboardDismissMode = .interactive
    
    self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    addComponentsToInputContainerView()
  }
  
  override var inputAccessoryView: UIView? {
    get {
      return inputContainerView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  func addComponentsToInputContainerView() {
    inputContainerView.addSubview(uploadImageButton)
    inputContainerView.addSubview(sendButton)
    inputContainerView.addSubview(inputTextField)
    inputContainerView.addSubview(inputSeparatorLine)
    
    _ = uploadImageButton.constraintCenterTo(centerX: nil, xConstant: nil, centerY: inputContainerView.centerYAnchor, yConstant: 0)
    _ = uploadImageButton.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 8, right: nil, rightConstant: nil)
    _ = uploadImageButton.constraintSizeToConstant(widthConstant: 44, heightConstant: 44)
    
    _ = sendButton.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: inputContainerView.rightAnchor, leftConstant: -48, right: inputContainerView.rightAnchor, rightConstant: -8)
    
    _ = inputTextField.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: inputContainerView.leftAnchor, leftConstant: 8, right: sendButton.leftAnchor, rightConstant: -8)
    
    _ = inputSeparatorLine.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.topAnchor, bottomConstant: 1, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
  }
}

extension ChatLogCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let messageCell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatMessageCollectionViewCell
    let message = messages[indexPath.item]
    
    messageCell?.isSent = Auth.auth().currentUser?.uid == message.fromId
    messageCell?.partnerProfilePictureUrl = partner?.profilePictureUrl
    if let messageText = message.text {
      messageCell?.messageText = messageText
      messageCell?.bubbleEstimatedWidth = estimateFrameForText(messageText).width + 24
    }
    
    return messageCell!
  }
}

extension ChatLogCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let message = messages[indexPath.item]
    
    var estimatedHeight: CGFloat = 0
    if let messageText = message.text {
      estimatedHeight = estimateFrameForText(messageText).height + 18
    } else {
      estimatedHeight = 150
    }
    return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight)
  }
  
  fileprivate func estimateFrameForText(_ text: String) -> CGRect {
    let textAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)]
    return text.estimateFrameFor(size: CGSize(width: 200, height: 1000), attributes: textAttributes)
  }
}

extension ChatLogCollectionViewController {
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    if messages.count > 0 {
//      let lastItem = IndexPath(item: messages.count, section: 0)
//      self.collectionView?.scrollToItem(at: lastItem , at: .bottom, animated: false)
//    }
//  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    self.collectionView?.collectionViewLayout.invalidateLayout()
  }
}

