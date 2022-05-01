//
//  OTPViewModel.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/25.
//

import ComposableArchitecture

struct OTPField: Equatable {
  let index: Int
  var text: String
  var isHighlight: Bool
}

struct OTPFieldState: Equatable {
  var fields: [OTPField] = []
  var totalFieldIndex: Int = 0
  var otpFields: [String] = Array(repeating: "", count: 4)
  var otpText: String = ""
  var focusedFieldIndex: Int = 0
  
  var result: String {
    let texts = fields.map { $0.text }
    let result = texts.reduce("") { $0 + $1 }
    return result
  }
}

enum OTPFieldAction: Equatable {
  case activeField(index: Int, content: String)
  case valueChanged
  case checkValue
  case lastFieldTrigger
}

struct OTPFieldEnvironment { }

let otpFieldReducer = Reducer<
  OTPFieldState,
  OTPFieldAction,
  OTPFieldEnvironment
> { state, action, environment in
  switch action {
  case let .activeField(index, content):
    state.fields[index].text = content
    state.focusedFieldIndex = index
    return .merge([
      Effect(value: .checkValue),
      Effect(value: .valueChanged)
    ])
  case .valueChanged:
    return .none
  case .checkValue:
    if state.fields[state.focusedFieldIndex].text == "" {
      state.focusedFieldIndex -= 1
    }
    
    if state.fields[state.focusedFieldIndex].text != "" {
      state.focusedFieldIndex += 1
    }
    
    if state.focusedFieldIndex >= state.totalFieldIndex {
      return Effect(value: .lastFieldTrigger)
    }
    return .none
  case .lastFieldTrigger:
    return .none
  }
}
