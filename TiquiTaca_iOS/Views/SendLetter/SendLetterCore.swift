//
//  SendLetterCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/10.
//

import Combine
import ComposableArchitecture
import TTNetworkModule

struct SendLetterState: Equatable {
  var userId: String
}

enum SendLetterAction: Equatable {
  case onAppear
}

struct SendLetterEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let sendLetterReducer = Reducer<
  SendLetterState,
  SendLetterAction,
  SendLetterEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  default:
    return .none
  }
}
