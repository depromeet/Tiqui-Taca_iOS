//
//  String+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/13.
//

import Foundation

extension String {
  func checkNickname() -> Bool {
    let regex = "^[가-힣A-Za-z0-9]{2,10}$"
    return checkValidation(regex)
  }
  
  func checkPhoneNumber() -> Bool {
    let regex = "^01([0-9])([0-9]{4})([0-9]{4})$"
    return checkValidation(regex)
  }
  
  func checkValidation(_ regex: String) -> Bool {
    let pred = NSPredicate(format: "SELF MATCHES %@", regex)
    return pred.evaluate(with: self)
  }
  
  func getTimeStringFromDateString() -> String {
    let iso8601Formatter = ISO8601DateFormatter()
    let createdDate = iso8601Formatter.date(from: self)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.string(for: createdDate) ?? ""
  }
  
  func getTimeTodayOrDate() -> String {
    let iso8601Formatter = ISO8601DateFormatter()
    let createdDate = iso8601Formatter.date(from: self)
    
    let dateFormatterExceptTime = DateFormatter()
    dateFormatterExceptTime.dateFormat = "yyyy-MM-dd"
    let createdDateExceptTime = dateFormatterExceptTime.string(for: createdDate)
    let currentDateExceptTime = dateFormatterExceptTime.string(for: Date())
    
    if createdDateExceptTime == currentDateExceptTime {
      let timeFormatter = DateFormatter()
      timeFormatter.dateFormat = "HH:mm"
      return timeFormatter.string(for: createdDate) ?? ""
    } else {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MM/dd"
      return dateFormatter.string(for: createdDate) ?? ""
    }
  }
}
