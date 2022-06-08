//
//  MessageCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import ComposableArchitecture

struct MessageState: Equatable {
}

struct MessageAction: Equatable {
}

struct MessageEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let messageReducer = Reducer<
  MessageState,
  MessageAction,
  MessageEnvironment
>.combine([
  messageCore
])

let messageCore = Reducer<
  MessageState,
  MessageAction,
  MessageEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
