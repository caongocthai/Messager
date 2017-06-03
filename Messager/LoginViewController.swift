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
  var delegate: SetNavTitleAndPresentProfilePicturePickerDelegate?
  
  var isInLoginMenu = true
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "logo")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var loginRegisterSegmentedControl: UISegmentedControl = {
    let segmentedConstrol = UISegmentedControl(items: ["Login","Register"])
    segmentedConstrol.selectedSegmentIndex = 0
    segmentedConstrol.tintColor = .white
    segmentedConstrol.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
    return segmentedConstrol
  }()
  
  let inputContainerView: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 8
    return containerView
  }()
  var inputContainerViewContraints: [NSLayoutConstraint]?
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Name"
    return textField
  }()
  var nameTextFieldContraints: [NSLayoutConstraint]?
  
  let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Email address"
    textField.keyboardType = .emailAddress
    textField.autocapitalizationType = .none
    return textField
  }()
  var emailTextFieldContraints: [NSLayoutConstraint]?
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let nameEmailSeparator: UIView = {
    let line = UIView()
    line.backgroundColor = .lightGray
    return line
  }()
  
  let emailPasswordSeparator: UIView = {
    let line = UIView()
    line.backgroundColor = .lightGray
    return line
  }()
  
  lazy var loginRegisterButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
    button.setTitleColor(.darkRed, for: .normal)
    button.backgroundColor = UIColor(r: 250, g: 215, b: 65, a: 1)
    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    self.view.backgroundColor = .darkYellow
    
    addInputView()
    addLoginRegisterSegmentedControl()
    addProfileImageView()
    addLoginRegisterButton()
    
    observeKeyboardNotificaton()
    hideKeyboard()
  }
  
  func addProfileImageView() {
    self.view.addSubview(profileImageView)
    
    _ = profileImageView.constraintAnchorTo(top: nil, topConstant: nil, bottom: loginRegisterSegmentedControl.topAnchor, bottomConstant: -32, left: nil, leftConstant: nil, right: nil, rightConstant: nil)
    _ = profileImageView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: nil, yConstant: nil)
    _ = profileImageView.constraintSizeToConstant(widthConstant: 220, heightConstant: 130)
  }
  
  func addLoginRegisterSegmentedControl() {
    self.view.addSubview(loginRegisterSegmentedControl)
    
    _ = loginRegisterSegmentedControl.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: nil, yConstant: nil)
    _ = loginRegisterSegmentedControl.constraintAnchorTo(top: nil, topConstant: nil, bottom: inputContainerView.topAnchor, bottomConstant: -16, left: nil, leftConstant: nil, right: nil, rightConstant: nil)
    _ = loginRegisterSegmentedControl.constraintSizeToMultipler(widthAnchor: inputContainerView.widthAnchor, widthMultiplier: 1, heightAnchor: nil, heightMultiplier: nil)
    _ = loginRegisterSegmentedControl.constraintSizeToConstant(widthConstant: nil, heightConstant: 30)
  }
  
  func addInputView() {
    self.view.addSubview(inputContainerView)
    self.view.addSubview(nameTextField)
    self.view.addSubview(emailTextField)
    self.view.addSubview(passwordTextField)
    self.view.addSubview(nameEmailSeparator)
    self.view.addSubview(emailPasswordSeparator)
    
    _ = inputContainerView.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: self.view.centerYAnchor, yConstant: 0)
    _ = inputContainerView.constraintAnchorTo(top: nil, topConstant: nil, bottom: nil, bottomConstant: nil, left: self.view.leftAnchor, leftConstant: 30, right: self.view.rightAnchor, rightConstant: -30)
    inputContainerViewContraints = inputContainerView.constraintSizeToConstant(widthConstant: nil, heightConstant: 100)
    
    _ = nameTextField.constraintAnchorTo(top: inputContainerView.topAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 10, right: inputContainerView.rightAnchor, rightConstant: 0)
    nameTextFieldContraints = nameTextField.constraintSizeToMultipler(widthAnchor: nil, widthMultiplier: nil, heightAnchor: inputContainerView.heightAnchor, heightMultiplier: 0)
    nameTextField.isHidden = isInLoginMenu
    
    _ = nameEmailSeparator.constraintAnchorTo(top: nameTextField.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = nameEmailSeparator.constraintSizeToConstant(widthConstant: nil, heightConstant: 1)
    nameEmailSeparator.isHidden = isInLoginMenu
    
    _ = emailTextField.constraintAnchorTo(top: nameEmailSeparator.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: nameTextField.leftAnchor, leftConstant: 0, right: nameTextField.rightAnchor, rightConstant: 0)
    emailTextFieldContraints = emailTextField.constraintSizeToMultipler(widthAnchor: nil, widthMultiplier: nil, heightAnchor: inputContainerView.heightAnchor, heightMultiplier: 1/2)
    
    _ = emailPasswordSeparator.constraintAnchorTo(top: emailTextField.bottomAnchor, topConstant: 0, bottom: nil, bottomConstant: nil, left: inputContainerView.leftAnchor, leftConstant: 0, right: inputContainerView.rightAnchor, rightConstant: 0)
    _ = emailPasswordSeparator.constraintSizeToConstant(widthConstant: nil, heightConstant: 1)
    
    _ = passwordTextField.constraintAnchorTo(top: emailPasswordSeparator.bottomAnchor, topConstant: 0, bottom: inputContainerView.bottomAnchor, bottomConstant: 0, left: nameTextField.leftAnchor, leftConstant: 0, right: nameTextField.rightAnchor, rightConstant: 0)
  }
  
  func addLoginRegisterButton() {
    self.view.addSubview(loginRegisterButton)
    _ = loginRegisterButton.constraintAnchorTo(top: inputContainerView.bottomAnchor, topConstant: 16, bottom: inputContainerView.bottomAnchor, bottomConstant: 61, left: nil, leftConstant: nil, right: nil, rightConstant: nil)
    _ = loginRegisterButton.constraintCenterTo(centerX: self.view.centerXAnchor, xConstant: 0, centerY: nil, yConstant: nil)
    _ = loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
  }
}
