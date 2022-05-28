//
//  PopularChatRoomListCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import ComposableArchitecture

struct PopularChatRoomListState: Equatable {
  
}

enum PopularChatRoomListAction: Equatable {
  
}

struct PopularChatRoomListEnvironment {
  var appService: AppService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let popularChatRoomListReducer = Reducer<
  PopularChatRoomListState,
  PopularChatRoomListAction,
  PopularChatRoomListEnvironment
>.combine([
  popularChatRoomListCore
])

let popularChatRoomListCore = Reducer<
  PopularChatRoomListState,
  PopularChatRoomListAction,
  PopularChatRoomListEnvironment
> { state, action, environment in
  switch action {
    
  }
}
