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
  enum Route {
    case questionDetail
    case menu
  }
  var roomId: String
  var route: Route?
  var currentRoom: RoomInfoEntity.Response = .init()
  var myInfo: UserEntity.Response?
  
  var isFirstLoad = true
  var moveToOtherView = false
  var chatLogList: [ChatLogEntity.Response] = []
  
  var otherProfileState: OtherProfileState = .init()
  var chatMenuState: ChatMenuState = .init()
  var questionDetailViewState: QuestionDetailState = .init(questionId: "")
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
  
  case setRoute(ChatDetailState.Route?)
  case selectProfile(UserEntity.Response?)
  case selectQuestionDetail(String)
  case selectMenu
  case joinRoom
  case enteredRoom(Result<RoomInfoEntity.Response?, HTTPError>)
  case questionDetail(Result<QuestionEntity.Response?, HTTPError>)
  case moveToOtherView
  
  case locationManager(LocationManager.Action)
  case otherProfileAction(OtherProfileAction)
  case chatMenuAction(ChatMenuAction)
  case questionDetailAction(QuestionDetailAction)
}

struct ChatDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let locationManager: LocationManager
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
  questionDetailReducer
    .pullback(
      state: \.questionDetailViewState,
      action: /ChatDetailAction.questionDetailAction,
      environment: {
        QuestionDetailEnvironment.init(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  otherProfileReducer
    .pullback(
      state: \.otherProfileState,
      action: /ChatDetailAction.otherProfileAction,
      environment: {
        OtherProfileEnvironment.init(
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
    state.isFirstLoad = false
    return .merge(
      environment.locationManager
        .delegate()
        .map(ChatDetailAction.locationManager),
      Effect(value: .joinRoom)
        .eraseToEffect(),
      environment.appService.socketService
        .connect(state.roomId)
        .receive(on: environment.mainQueue)
        .map(ChatDetailAction.socket)
        .eraseToEffect()
        .cancellable(id: ChatDetailId()),
      environment.locationManager
        .startMonitoringSignificantLocationChanges()
        .fireAndForget()
    )
  case .onDisAppear:
    guard !state.moveToOtherView else { return .none }
    return environment.appService.socketService
      .disconnect(state.roomId)
      .eraseToEffect()
      .fireAndForget()
  // MARK: Socket
  case let .sendMessage(chat):
    print("send Message")
    return environment.appService.socketService
      .send(state.roomId, chat)
      .eraseToEffect()
      .map(ChatDetailAction.sendResponse)
  case let .socket(.initialMessages(messages)):
    state.chatLogList = messages
    return .none
  case let .socket(.newMessage(message)):
    state.chatLogList.append(message)
    return .none
  case let .selectProfile(user):
    state.otherProfileState = OtherProfileState(otherUser: user)
    return .none
  case let .selectQuestionDetail(chatId):
    state.route = nil
    return environment.appService.questionService
      .getQuestionDetailAtChat(chatId: chatId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.questionDetail)
  case .joinRoom:
    return environment.appService.roomService
      .joinRoom(roomId: state.roomId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.enteredRoom)
  // MARK: API Result
  case let .enteredRoom(.success(res)):
    if let res = res {
      state.currentRoom = res
      state.chatMenuState = ChatMenuState(roomInfo: res)
    }
    return .none
  case let .questionDetail(.success(res)):
    guard let questionId = res?.id else { return .none }
    state.moveToOtherView = true
    state.questionDetailViewState = .init(questionId: questionId)
    print("와이 no click", questionId)
    state.route = .questionDetail
  case .moveToOtherView:
    state.moveToOtherView = true
    return .none
  case let .setRoute(route):
    state.moveToOtherView = true
    state.route = route
    return .none
  case .enteredRoom(.failure), .questionDetail(.failure):
    return .none
  case let .locationManager(.didUpdateLocations(locations)):
    print("로케이션 받아옴", locations.first?.coordinate.latitude, locations.first?.coordinate.longitude)
    return .none
  default:
    return .none
  }
  
  return .none
}
