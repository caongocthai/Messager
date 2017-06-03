//
//  ChatLogCollectionViewController.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ChatLogCollectionViewController: UICollectionViewController {
  var partner: User? {
    didSet {
      guard let partner = partner else { return }
      self.navigationItem.title = partner.name
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

