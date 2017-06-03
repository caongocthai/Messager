//
//  UIImageView+extension.swift
//  Messager
//
//  Created by Harry Cao on 2/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  func loadImageUsingCache(with urlString: String) {
    // Prevent deque cell reuse the image of another cell
    self.image = nil
    
    // check cache
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      self.image = cachedImage
      return
    }
    
    // If no cachedImage, fire a new download
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, res, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let data = data else { return }
      DispatchQueue.main.async(execute: {
        guard let downloadedImage = UIImage(data: data) else { return }
        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
        self.image = downloadedImage
      })
    }.resume()
  }
}
