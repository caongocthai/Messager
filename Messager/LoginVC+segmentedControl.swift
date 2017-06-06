//
//  LoginVC+segmentedControl.swift
//  Messager
//
//  Created by Harry Cao on 1/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

extension LoginViewController {
  func handleSegmentedControl() {
    let selectedIndex =  loginRegisterSegmentedControl.selectedSegmentIndex
    let currentMenu = loginRegisterSegmentedControl.titleForSegment(at: selectedIndex)
    isInLoginMenu = selectedIndex == 0
    
    loginRegisterButton.setTitle(currentMenu, for: .normal)
    
    inputContainerViewContraints?[0].constant = isInLoginMenu ? 100 : 150

    nameTextFieldContraints?.forEach{ $0.isActive = false }
    nameTextFieldContraints = nameTextField.constraintSizeToMultipler(widthAnchor: nil, widthMultiplier: nil, heightAnchor: inputContainerView.heightAnchor, heightMultiplier: isInLoginMenu ? 0 : 1/3)
    nameTextFieldContraints?.forEach{ $0.isActive = true }
    
    // Hide nameTextField and separator if in login
    nameTextField.isHidden = isInLoginMenu
    nameEmailSeparator.isHidden = isInLoginMenu
    
    emailTextFieldContraints?.forEach{ $0.isActive = false }
    emailTextFieldContraints = emailTextField.constraintSizeToMultipler(widthAnchor: nil, widthMultiplier: nil, heightAnchor: inputContainerView.heightAnchor, heightMultiplier: isInLoginMenu ? 1/2 : 1/3)
    emailTextFieldContraints?.forEach{ $0.isActive = true }
  }
}
