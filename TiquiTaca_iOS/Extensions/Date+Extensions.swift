//
//  Date+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/14.
//

import Foundation

enum DateFormatType: String {
  case HHmm = "HH:mm"
}

extension Date {
  static func current(type: DateFormatType) -> String {
    let dateString: String = Date().ISO8601Format()
    let iso8601DateFormatter = ISO8601DateFormatter()
    let date = iso8601DateFormatter.date(from: dateString)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = type.rawValue
    return dateFormatter.string(for: date ?? Date()) ?? ""
  }
  
  func getTimeString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.string(for: self) ?? ""
  }
  
  var relativeTimeAbbreviated: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: self, relativeTo: Date.now)
  }
}
