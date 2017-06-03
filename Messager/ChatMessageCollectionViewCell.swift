//
//  ChatMessageCollectionViewCell.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
  let messageTextView: UITextView = {
    let textView = UITextView()
    textView.textAlignment = .center
    textView.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightThin)
    textView.backgroundColor = .darkYellow
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addMessageTextView()
  }
  
  func addMessageTextView() {
    self.addSubview(messageTextView)
    _ = messageTextView.constraintAnchorTo(top: self.topAnchor, topConstant: 0, bottom: self.bottomAnchor, bottomConstant: 0, left: self.leftAnchor, leftConstant: 0, right: self.rightAnchor, rightConstant: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
