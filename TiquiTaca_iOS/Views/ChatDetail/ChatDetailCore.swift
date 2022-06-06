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
  var myInfo: UserEntity.Response?
  
  var isFirstLoad = true
  var moveToOtherView = false
  var chatLogList: [ChatLogEntity.Response] = []
  var receiveNewChat: Bool = false
  
  var chatMenuState: ChatMenuState = .init()
}

enum ChatDetailAction: Equatable {
  static func == (lhs: ChatDetailAction, rhs: ChatDetailAction) -> Bool {
    false
  }
  
  case onAppear
  case onDisAppear
  case connectSocket
  case disconnectSocket
  
  
  case sendMessage(SendChatEntity)
  case sendResponse(NSError?)
  case socket(SocketService.Action)
  
  case joinRoom
  case enteredRoom(Result<RoomInfoEntity.Response?, HTTPError>)
  case moveToOtherView
  
  case chatMenuAction(ChatMenuAction)
}

struct ChatDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatDetailReducer = Reducer<
  ChatDetailState,
  ChatDetailAction,
  ChatDetailEnvironment
>.combine([
  chatMenuReducer
    .pullback(
      state: \.chatMenuState,
      action: /ChatDetailAction.chatMenuAction,
      environment: {
        ChatMenuEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  chatDetailCore
])

struct ChatDetailId: Hashable { }

let chatDetailCore = Reducer<
  ChatDetailState,
  ChatDetailAction,
  ChatDetailEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    state.moveToOtherView = false
    
    guard state.isFirstLoad else { return .none }
    state.myInfo = environment.appService.userService.myProfile
    state.chatMenuState = ChatMenuState(roomInfo: state.currentRoom)
    state.isFirstLoad = false
    return .merge(
      Effect(value: .joinRoom),
      environment.appService.socketService
        .connect(state.currentRoom.id ?? "")
        .receive(on: environment.mainQueue)
        .map(ChatDetailAction.socket)
        .eraseToEffect()
        .cancellable(id: ChatDetailId())
    )
  case .onDisAppear:
    guard !state.moveToOtherView else { return .none }
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
    state.receiveNewChat.toggle()
    return .none
  case .joinRoom:
    return environment.appService.roomService
      .joinRoom(roomId: state.currentRoom.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.enteredRoom)
  case let .enteredRoom(.success(res)):
    return .none
  case .moveToOtherView:
    state.moveToOtherView = true
    return .none
  case .enteredRoom(.failure):
    return .none
  default:
    return .none
  }
}
