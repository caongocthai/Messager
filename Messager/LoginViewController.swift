//
//  LoginViewController.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  var delegate: ViewController?
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "logo")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let inputContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 8
    return containerView
  }()
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Name"
    return textField
  }()
  
  
  let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Email address"
    textField.keyboardType = .emailAddress
    return textField
  }()
  
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let separatorLine: UIView = {
    let line = UIView()
    line.backgroundColor = .lightGray
    return line
  }()
  
  lazy var loginRegisterButton: UIButton = {
    let button = UIButton(type: .system)
    let atttributedTitle = NSAttributedString(string: "Register", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor(r: 145, g: 14, b: 37, a: 1)])
    button.setAttributedTitle(atttributedTitle, for: .normal)
    button.backgroundColor = UIColor(r: 250, g: 215, b: 65, a: 1)
    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor(r: 240, g: 197, b: 48, a: 1)
    
    addInputView()
    addProfileImageView()
    addLoginRegisterButton()
    
    observeKeyboardNotificaton()
    hideKeyboard()
  }
  
  func addProfileImageView() {
    self.view.addSubview(profileImageView)
    
    _ = profileImageView.constraintAnchorTo(top: nil, topConstant: nil, bottom: inputContainerView.topAnchor, bottomConstant: -32, left: nil, leftConstant: nil, right: nil, rightConstant: nil)
    _ = profileImageView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: nil, yConstant: nil)
    _ = profileImageView.constraintSizeToConstant(widthConstant: 240, heightConstant: 145)
  }
  
  func addInputView() {
    self.view.addSubview(inputContainerView)
    self.view.addSubview(nameTextField)
    self.view.addSubview(emailTextField)
    self.view.addSubview(passwordTextField)
    
    let nameEmailSeparator = separatorLine.copyView() as! UIView
    let emailPasswordSeparator = separatorLine.copyView() as! UIView
    self.view.addSubview(nameEmailSeparator)
    self.view.addSubview(emailPasswordSeparator)
    
    _ = inputContainerView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: self.view.centerYAnchor, yConstant: 0)
    _ = inputContainerView.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: self.view.leftAnchor, leftConstant: 50, right: self.view.rightAnchor, rightConstant: -50)
    _ = inputContainerView.constraintSizeToConstant(widthConstant: nil, heightConstant: 150)
    
    _ = nameTextField.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 10, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = nameTextField.constraintSizeToConstant(widthConstant: nil, heightConstant: 50)
    
    _ = nameEmailSeparator.constraintAnchorTo(top: nameTextField.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = nameEmailSeparator.constraintSizeToConstant(widthConstant: nil, heightConstant: 1)
    
    _ = emailTextField.constraintAnchorTo(top: nameEmailSeparator.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: nameTextField.leftAnchor, leftConstant: 0, right: nameTextField.rightAnchor, rightConstant: 0)
    _ = emailTextField.constraintSizeToConstant(widthConstant: nil, heightConstant: 50)
    
    _ = emailPasswordSeparator.constraintAnchorTo(top: emailTextField.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = emailPasswordSeparator.constraintSizeToConstant(widthConstant: nil, heightConstant: 1)
    
    _ = passwordTextField.constraintAnchorTo(top: emailPasswordSeparator.bottomAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: nameTextField.leftAnchor, leftConstant: 0, right: nameTextField.rightAnchor, rightConstant: 0)
  }
  
  func addLoginRegisterButton() {
    self.view.addSubview(loginRegisterButton)
    _ = loginRegisterButton.constraintAnchorTo(top: inputContainerView.bottomAnchor, topConstant: 16, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = loginRegisterButton.constraintSizeToConstant(widthConstant: nil, heightConstant: 50)
  }
}
