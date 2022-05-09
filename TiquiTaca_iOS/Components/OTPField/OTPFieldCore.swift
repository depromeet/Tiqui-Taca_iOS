//
//  OTPViewModel.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/25.
//

import ComposableArchitecture

struct OTPField: Equatable, Identifiable {
  var id: Int
  var text: String
  
  var isFilled: Bool {
    return !text.isEmpty
  }
}

struct OTPFieldState: Equatable {
  var fields: [OTPField] = [
    .init(id: 0, text: ""),
    .init(id: 1, text: ""),
    .init(id: 2, text: ""),
    .init(id: 3, text: "")
  ]
  var focusedFieldIndex: Int = 0
  
  var result: String {
    let texts = fields.map { $0.text }
    let result = texts.reduce("") { $0 + $1 }
    return result
  }
}

enum OTPFieldAction: Equatable {
  case activeField(index: Int, content: String)
  case checkValue
  case lastFieldTrigger
}

let otpFieldReducer = Reducer<
  OTPFieldState,
  OTPFieldAction,
  Void
> { state, action, _ in
  switch action {
  case let .activeField(index, content):
    state.fields[index].text = content
    state.focusedFieldIndex = index
    return Effect(value: .checkValue)
  case .checkValue:
    if state.fields[state.focusedFieldIndex].text.isEmpty {
      state.focusedFieldIndex -= 1
    } else {
      state.focusedFieldIndex += 1
    }
    
    if state.focusedFieldIndex >= state.fields.count {
      return Effect(value: .lastFieldTrigger)
    } else {
      return .none
    }
  case .lastFieldTrigger:
    return .none
  }
}
