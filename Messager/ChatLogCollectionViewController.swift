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
  var timer: Timer?
  
  // For zooming image message
  var startingImageView: UIImageView?
  var startingImageViewFrame: CGRect?
  let blackBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0
    return view
  }()
  
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
  
  lazy var uploadImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "upload_image_icon")
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
    return imageView
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
  
  let uploadingProgressLine: UIView = {
    let line = UIView()
    line.backgroundColor = UIColor(r: 51, g: 102, b: 187, a: 1)
    return line
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    self.collectionView?.alwaysBounceVertical = true
    self.collectionView?.backgroundColor = .white
    self.collectionView?.showsVerticalScrollIndicator = false
    self.collectionView?.keyboardDismissMode = .interactive
    
    self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    
    NotificationCenter.default.addObserver(self, selector: #selector(scrollToLastMessage), name: .UIKeyboardDidShow, object: nil)
    
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
    inputContainerView.addSubview(uploadImageView)
    inputContainerView.addSubview(sendButton)
    inputContainerView.addSubview(inputTextField)
    inputContainerView.addSubview(inputSeparatorLine)
    inputContainerView.addSubview(uploadingProgressLine)
    
    _ = uploadImageView.constraintCenterTo(centerX: nil, xConstant: nil, centerY: inputContainerView.centerYAnchor, yConstant: 0)
    _ = uploadImageView.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 8, right: nil, rightConstant: nil)
    _ = uploadImageView.constraintSizeToConstant(widthConstant: 44, heightConstant: 44)
    
    _ = sendButton.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: inputContainerView.rightAnchor, leftConstant: -48, right: inputContainerView.rightAnchor, rightConstant: -8)
    
    _ = inputTextField.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: uploadImageView.rightAnchor, leftConstant: 8, right: sendButton.leftAnchor, rightConstant: -8)
    
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
    
    if let imageUrl = message.imageUrl {
      messageCell?.imageUrl = imageUrl
      messageCell?.bubbleEstimatedWidth = 200
      messageCell?.delegate = self
    }
    
    if let videoUrl = message.videoUrl {
      messageCell?.videoUrl = videoUrl
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
    }
    if let imageWidth = message.imageWidth as? CGFloat, let imageHeight = message.imageHeight as? CGFloat {
      estimatedHeight = imageHeight * 200 / imageWidth
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
  
  func scrollToLastMessage() {
    if messages.count > 0 {
      let indexPath = IndexPath(item: messages.count - 1, section: 0)
      collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    self.collectionView?.collectionViewLayout.invalidateLayout()
  }
}

