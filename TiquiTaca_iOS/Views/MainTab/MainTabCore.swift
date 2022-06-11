//
//  MainTabCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture
import ComposableCoreLocation

struct MainTabState: Equatable {
  var selectedTab: TabViewType = .map
  
  var mainMapState: MainMapState = .init()
  var chatState: ChatState = .init()
  var msgAndNotiState: MsgAndNotiState = .init()
  var myPageState: MyPageState = .init()
}

enum MainTabAction: Equatable {
  case setSelectedTab(TabViewType)
  
  case mainMapAction(MainMapAction)
  case chatAction(ChatAction)
  case msgAndNotiAction(MsgAndNotiAction)
  case myPageAction(MyPageAction)
}

struct MainTabEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var locationManager: LocationManager
}

let mainTabReducer = Reducer<
  MainTabState,
  MainTabAction,
  MainTabEnvironment
>.combine([
  mainMapReducer
    .pullback(
      state: \.mainMapState,
      action: /MainTabAction.mainMapAction,
      environment: {
        MainMapEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue,
          locationManager: $0.locationManager
        )
      }
    ),
  chatReducer
    .pullback(
      state: \.chatState,
      action: /MainTabAction.chatAction,
      environment: {
        ChatEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue,
          locationManager: $0.locationManager
        )
      }
    ),
  msgAndNotiReducer
    .pullback(
      state: \.msgAndNotiState,
      action: /MainTabAction.msgAndNotiAction,
      environment: {
        MsgAndNotiEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  myPageReducer
    .pullback(
      state: \.myPageState,
      action: /MainTabAction.myPageAction,
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
> { state, action, _ in
  switch action {
  case let .setSelectedTab(selectedTab):
    state.selectedTab = selectedTab
    return .none
    
  case let .mainMapAction(.setIsMoveToChatDetail(isMoveToChatDetail)):
    if isMoveToChatDetail {
      state.selectedTab = .chat
    }
    return .none
    
  case .mainMapAction:
    return .none
    
  case .chatAction:
    return .none
    
  case .msgAndNotiAction:
    return .none
    
  case .myPageAction:
    return .none
  }
}
