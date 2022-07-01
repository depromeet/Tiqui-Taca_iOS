//
//  MsgAndNotiCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

enum MsgAndNotiType: Equatable {
  case letter
  case notification
}

struct MsgAndNotiState: Equatable {
  var selectedType: MsgAndNotiType = .letter
  var letterState: LetterState = .init()
  var notificationState: NotificationState = .init()
}

enum MsgAndNotiAction: Equatable {
  case setSelectedType(MsgAndNotiType)
  case letterAction(LetterAction)
  case notificationAction(NotificationAction)
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
  letterReducer
    .pullback(
      state: \.letterState,
      action: /MsgAndNotiAction.letterAction,
      environment: {
        LetterEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  notificationReducer
    .pullback(
      state: \.notificationState,
      action: /MsgAndNotiAction.notificationAction,
      environment: {
        NotificationEnvironment(
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
  case .letterAction:
    return .none
  case .notificationAction:
    return .none
  }
}
