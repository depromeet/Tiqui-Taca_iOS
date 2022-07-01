//
//  OTPViewModel.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/25.
//

import ComposableArchitecture

struct OTPFieldState: Equatable {
}

enum OTPFieldAction: Equatable {
  case lastFieldTrigger(String)
}

let otpFieldReducer = Reducer<
  OTPFieldState,
  OTPFieldAction,
  Void
> { _, action, _ in
  switch action {
  case .lastFieldTrigger:
    return .none
  }
}
