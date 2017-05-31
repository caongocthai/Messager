//
//  LoginVC+keyboardObserver.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

// Shift the view up when keyboard popup
extension LoginViewController {
  // Setting up the keyboard
  
  func observeKeyboardNotificaton() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
  }
  
  func keyboardShow(notification: Notification) {
    let distanceLoginButtonAndBottom = self.view.bounds.height/2 - (150/2 + 16 + 50)
    
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardHeight = keyboardRectangle.height
    
    let offset = keyboardHeight - distanceLoginButtonAndBottom
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.frame = CGRect(x: 0, y: offset > 0 ? -offset - 10 : offset < 10 ? -10 : 0, width: self.view.frame.width, height: self.view.frame.height)
    }, completion: nil)
  }
  
  func keyboardHide() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }, completion: nil)
  }
}


// Hide keyboard when tap outside of textField
extension LoginViewController {
  func hideKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    self.view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}
