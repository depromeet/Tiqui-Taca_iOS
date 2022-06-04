//
//  ChatDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/01.
//


import Combine
import ComposableArchitecture
import TTNetworkModule
import SwiftUI

struct ChatDetailState: Equatable {
  var currentRoom: RoomInfoEntity.Response = .init()
  var isFirstLoad = true
  
  var chatLogList: [ChatLogEntity.Response] = []
}

enum ChatDetailAction: Equatable {
  static func == (lhs: ChatDetailAction, rhs: ChatDetailAction) -> Bool {
    true
  }
  
  case onAppear
  case onDisAppear
  case connectSocket
  case disconnectSocket
  case sendMessage(SendChatEntity)
  case sendResponse(NSError?)
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
    state.isFirstLoad = false
    
    return environment.appService.socketService
      .connect(state.currentRoom.id ?? "")
      .receive(on: environment.mainQueue)
      .map(ChatDetailAction.socket)
      .eraseToEffect()
      .cancellable(id: state.currentRoom.id ?? "")
  case .onDisAppear:
    return environment.appService.socketService
      .disconnect(state.currentRoom.id ?? "")
      .eraseToEffect()
      .fireAndForget()
  case let .sendMessage(chat):
    print("send Message")
    return environment.appService.socketService
      .send(state.currentRoom.id ?? "", chat)
      .eraseToEffect()
      .map(ChatDetailAction.sendResponse)
  case let .socket(.initialMessages(messages)):
    state.chatLogList = messages
    return .none
  case let .socket(.newMessage(message)):
    state.chatLogList.append(message)
    return .none
  default:
    return .none
  }
}
