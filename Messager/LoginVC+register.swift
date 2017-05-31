//
//  LoginVC+register.swift
//  Messager
//
//  Created by Harry Cao on 1/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation
import Firebase

extension LoginViewController {
  func handleRegister() {
    guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if (error != nil) {
        print(error ?? "failed to authenticate user")
        return
      }
      
      // sucessfully authenticated user
      
      guard let uid = user?.uid else { return }
      
      let ref = Database.database().reference(fromURL: "https://theflashmessager.firebaseio.com/")
      let userReference = ref.child("users").child(uid)
      
      let values = ["name": name, "email": email]
      userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
        if (err != nil) {
          print(err ?? "failed to save user into Firebase database")
          return
        }
        
        // Successfully save user into Firebase database
        print("\nSuccessfully save user into Firebase database\n", ref)
        self.delegate?.userName = name
        self.dismiss(animated: true, completion: { 
          // maydo smth
        })
      })
    }
  }
}
