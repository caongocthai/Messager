//
//  ViewController.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var userName: String? {
    didSet {
      guard let userName = userName else { return }
      greetingLabel.text = "Run " + userName + ", run!"
    }
  }
  
  let greetingLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.init(name: "HelveticaNeue-Medium", size: 40)
    label.textAlignment = .center
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = .cyan
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    
    self.view.addSubview(greetingLabel)
    _ = greetingLabel.constraintAnchorTo(top: self.view.topAnchor, topConstant: 0, bottom: self.view.bottomAnchor, bottomConstant: 0, left: self.view.leftAnchor, leftConstant: 0, right: self.view.rightAnchor, rightConstant: 0)
  }
  
  func handleLogout() {
    let loginViewController = LoginViewController()
    loginViewController.delegate = self
    self.present(loginViewController, animated: true) { 
      // may do smth later
    }
  }

}

