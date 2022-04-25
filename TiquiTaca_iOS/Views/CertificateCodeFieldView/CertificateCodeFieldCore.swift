//
//  CertificateCodeFieldCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/23.
//

import ComposableArchitecture

struct CertificateCodeState: Equatable {
  var certificateCodeModels: [CertificateCodeField]
  var isAllFilled = false
  var certificateError = false
}

enum CertificateCodeAction: Equatable {
  case isTyping(String)
  case checkAllFilled
  case isEmpty
}

struct CertificateCodeEnvironment { }

let certificateCodeReducer = Reducer<
  CertificateCodeState,
  CertificateCodeAction,
  CertificateCodeEnvironment
> { state, action, _ in
  switch action {
  case let .isTyping(inputNum):
    state.certificateCodeModels = state.certificateCodeModels.map {
      var model = $0
//      if $0.index == index {
        model.inputNumber = inputNum
        model.isFilled = !model.inputNumber.isEmpty
//      }
      return model
    }
    return .none
  case .checkAllFilled:
    let emptyCount = state.certificateCodeModels.filter {
      $0.inputNumber.isEmpty
    }
    state.isAllFilled = !emptyCount.isEmpty
    return .none
  case .isEmpty:
    return .none
  }
}
