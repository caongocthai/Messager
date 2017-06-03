//
//  PresentProfilePicturePickerDelegate.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

protocol SetNavTitleAndPresentProfilePicturePickerDelegate: class {
  func presentProfilePicturePicker(with values: [String: Any])
  func setNavigationTitle(with title: String)
  func setNavigationTitleByAccessingDatabase()
}
