//
//  MainTabCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MainTabState: Equatable {
  // Feature State
  var mapFeature: MapState = .init()
  var chatFeature: ChatState = .init()
  var msgAndNotiFeature: MsgAndNotiState = .init()
  var myPageFeature: MyPageState = .init()
}

enum MainTabAction: Equatable {
  // Feature Action
  case mapFeature(MapAction)
  case chatFeature(ChatAction)
  case msgAndNotiFeature(MsgAndNotiAction)
  case myPageFeature(MyPageAction)
}

struct MainTabEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let mainTabReducer = Reducer<
  MainTabState,
  MainTabAction,
  MainTabEnvironment
>.combine([
  mapReducer
    .pullback(
      state: \.mapFeature,
      action: /MainTabAction.mapFeature,
      environment: {
        MapEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  chatReducer
    .pullback(
      state: \.chatFeature,
      action: /MainTabAction.chatFeature,
      environment: {
        ChatEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  msgAndNotiReducer
    .pullback(
      state: \.msgAndNotiFeature,
      action: /MainTabAction.msgAndNotiFeature,
      environment: {
        MsgAndNotiEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  myPageReducer
    .pullback(
      state: \.myPageFeature,
      action: /MainTabAction.myPageFeature,
      environment: {
        MyPageEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  mainTabCore
])

let mainTabCore = Reducer<
  MainTabState,
  MainTabAction,
  MainTabEnvironment
> { state, action, environment in
  switch action {
  case .mapFeature:
    return .none
  case .chatFeature:
    return .none
  case .msgAndNotiFeature:
    return .none
  case .myPageFeature:
    return .none
  }
}
