//
//  Double+getTimeAgoString.swift
//  Messager
//
//  Created by Harry Cao on 4/6/17.
//  Copyright © 2017 Harry Cao. All rights reserved.
//

import Foundation

extension Double {
  func getTimeAgoString() -> String {
    if self < 60 {
      let secondInt = Int(self)
      return String(secondInt) + "s ago"
    } else if self < 60*60 {
      let minuteInt = Int(self/60)
      return String(minuteInt) + "m ago"
    } else if self < 60*60*24 {
      let hourInt = Int(self/60/60)
      return String(hourInt) + "h ago"
    } else if self < 60*60*24*7 {
      let dayInt = Int(self/60/60/24)
      return String(dayInt) + "d ago"
    } else if self < 60*60*24*30 {
      let weekInt = Int(self/60/60/24/7)
      return String(weekInt) + "w ago"
    } else if self < 60*60*24*365.25 {
      let monthInt = Int(self/60/60/24/30)
      return String(monthInt) + "mon ago"
    } else {
      let yearInt = Int(self/60/60/24/365.25)
      return String(yearInt) + "y ago"
    }
  }

  fileprivate func stringAppendedAtTheEnd(for number: Int) -> String {
    return number > 1 ? "s ago" : " ago"
  }
}
