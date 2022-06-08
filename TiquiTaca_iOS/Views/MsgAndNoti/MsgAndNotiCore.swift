//
//  MsgAndNotiCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

enum MsgAndNotiType: Equatable {
  case message
  case notification
}

struct MsgAndNotiState: Equatable {
  var selectedType: MsgAndNotiType = .message
  var messageState: MessageState = .init()
}

enum MsgAndNotiAction: Equatable {
  case setSelectedType(MsgAndNotiType)
  case messageAction(MessageAction)
}

struct MsgAndNotiEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let msgAndNotiReducer = Reducer<
  MsgAndNotiState,
  MsgAndNotiAction,
  MsgAndNotiEnvironment
>.combine([
  messageReducer
    .pullback(
      state: \.messageState,
      action: /MsgAndNotiAction.messageAction,
      environment: {
        MessageEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  msgAndNotiCore
])

let msgAndNotiCore = Reducer<
  MsgAndNotiState,
  MsgAndNotiAction,
  MsgAndNotiEnvironment
> { state, action, environment in
  switch action {
  case let .setSelectedType(type):
    state.selectedType = type
    return .none
  case .messageAction:
    return .none
  }
}
