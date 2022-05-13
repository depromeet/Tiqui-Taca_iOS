//
//  Int+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/10.
//

import Foundation

extension Int {
  /// format -> 00:00
  var timeString: String {
    let minutes = self / 60 % 60
    let seconds = self % 60
    return String(format: "%02i:%02i", minutes, seconds)
  }
}
