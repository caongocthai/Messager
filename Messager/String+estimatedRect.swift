//
//  String+estimatedRect.swift
//  Messager
//
//  Created by Harry Cao on 4/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

extension String {
  func estimateFrameFor(size: CGSize, attributes: [String : Any]?) -> CGRect {
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
  }
}
