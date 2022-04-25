//
//  OTPViewModel.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/25.
//

import Foundation


class OTPViewModel: ObservableObject {
  @Published var otpFields: [String] = Array(repeating: "", count: 4)
  var otpText: String = ""
}

enum OTPField {
  case field1
  case field2
  case field3
  case field4
}
