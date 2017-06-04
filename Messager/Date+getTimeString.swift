//
//  Date+getTimeString.swift
//  Messager
//
//  Created by Harry Cao on 4/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

extension Date {
  func getTimeString(with interval: Double) -> String {
    let dateFormatter = DateFormatter()
    
    if interval < 60*60*24 {
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter.string(from: self)
    } else if interval < 60*60*24*365 {
      dateFormatter.dateFormat = "MMM d"
      return dateFormatter.string(from: self)
    } else  {
      dateFormatter.dateFormat = "MMM y"
      return dateFormatter.string(from: self)
    }
  }
  
}
