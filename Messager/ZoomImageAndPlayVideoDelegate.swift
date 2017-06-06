//
//  ZoomImageAndPlayVideoDelegate.swift
//  Messager
//
//  Created by Harry Cao on 5/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

protocol ZoomImageAndPlayVideoDelegate: class {
  func performZoomInFor(_ startingImageView: UIImageView)
  func playVideoFor(url : URL)
}
