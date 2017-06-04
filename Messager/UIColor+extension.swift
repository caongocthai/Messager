//
//  UIColor+extension.swift
//  Messager
//
//  Created by Harry Cao on 31/5/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
  }

  static let darkYellow = UIColor(r: 240, g: 197, b: 48, a: 1)
  static let darkRed = UIColor(r: 145, g: 14, b: 37, a: 1)
  static let veryLightGray = UIColor(r: 240, g: 240, b: 240, a: 1)
}
