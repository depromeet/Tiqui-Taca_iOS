//
//  OTPField.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/24.
//

import Foundation

struct OTPField: Equatable, Identifiable {
  var id: Int
  var text: String
  
  var isFilled: Bool {
    return !text.isEmpty
  }
}
