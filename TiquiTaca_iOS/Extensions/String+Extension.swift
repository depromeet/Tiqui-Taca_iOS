//
//  String+Extension.swift
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
}
