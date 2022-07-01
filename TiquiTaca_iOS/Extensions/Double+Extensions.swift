//
//  Double+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/05.
//

import Foundation

extension Double {
  var prettyDistance: String {
    guard self > -.infinity else { return "?" }
    let formatter = LengthFormatter()
    formatter.numberFormatter.maximumFractionDigits = 2
    if self >= 1000 {
      return formatter.string(fromValue: self / 1000, unit: LengthFormatter.Unit.kilometer)
    } else {
      let value = Double(Int(self)) // 미터로 표시할 땐 소수점 제거
      return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
    }
  }
}
