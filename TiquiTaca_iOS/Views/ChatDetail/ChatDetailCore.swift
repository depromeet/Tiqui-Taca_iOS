//
//  ChatDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/01.
//


import Combine
import ComposableArchitecture
import ComposableCoreLocation
import TTNetworkModule
import SwiftUI

struct ChatDetailState: Equatable {
  var currentRoom: RoomInfoEntity.Response = .init()
  var isFirstLoad = true
}

enum ChatDetailAction: Equatable {
  case onAppear
  case connectSocket
  case disconnectSocket
  case receiveMessage
  case sendMessage
  case socket(SocketService.Action)
}

struct ChatDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatDetailReducer = Reducer<
  ChatDetailState,
  ChatDetailAction,
  ChatDetailEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    guard state.isFirstLoad else { return .none }
    
    return environment.appService.socketService
      .connect(state.currentRoom.id ?? "")
      .receive(on: environment.mainQueue)
      .map(ChatDetailAction.socket)
      .eraseToEffect()
      .cancellable(id: state.currentRoom.id ?? "")
  default:
    return .none
  }
}
