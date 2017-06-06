//
//  PresentChatLogDelegate.swift
//  Messager
//
//  Created by Harry Cao on 3/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

protocol PresentChatLogDelegate: class {
  func presentChatLog(of partner: User)
}
