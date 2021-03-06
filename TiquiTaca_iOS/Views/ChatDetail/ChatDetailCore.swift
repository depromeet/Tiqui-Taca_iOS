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
    case sendLetter
  }
  var roomId: String
  var route: Route?
  var currentLocation: CLLocationCoordinate2D?
  var currentRoom: RoomInfoEntity.Response = .init()
  var myInfo: UserEntity.Response?
  var blockUserList: [BlockUserEntity.Response]?
  
  var isFirstLoad = true
  var isFristGetLocation = true
  var isWithinRadius = false
  var isAlarmOn = false
  var showLocationToast = false
  var moveToOtherView = false
  var chatLogList: [ChatLogEntity.Response] = []
  
  var otherProfileState: OtherProfileState = OtherProfileState(userId: "")
  var chatMenuState: ChatMenuState = .init()
  var questionDetailViewState: QuestionDetailState = .init(questionId: "")
  var letterSendState: LetterSendState = .init()
  var focusMessageId: String?
}

enum ChatDetailAction: Equatable {
  static func == (lhs: ChatDetailAction, rhs: ChatDetailAction) -> Bool {
    false
  }
  
  case onAppear
  case onDisAppear
  
  case sendMessage(SendChatEntity)
  case sendResponse(NSError?)
  case connectSocket
  case disconnectSocket
  case socket(SocketService.Action)
  
  case checkLocationWithinRadius(CLLocationCoordinate2D)
  case selectProfile(UserEntity.Response?)
  case selectQuestionDetail(String)
  case selectMenu
  case selectSendLetter(UserEntity.Response?)
  case selectAlarm
  case joinRoom
  case getBlockUserList
  case responseJoinRoom(Result<RoomInfoEntity.Response?, HTTPError>)
  case responseQuestionDetail(Result<QuestionEntity.Response?, HTTPError>)
  case responseAlarm(Result<RoomAlarmResponse?, HTTPError>)
  case responseBlockUserList(Result<[BlockUserEntity.Response]?, HTTPError>)
  
  case setLocationToast(Bool)
  case setOtherProfileAction(OtherProfileState.Action)
  case moveToOtherView
  case setRoute(ChatDetailState.Route?) 
  
  case locationManager(LocationManager.Action)
  case chatMenuAction(ChatMenuAction)
  case questionDetailAction(QuestionDetailAction)
  case otherProfileAction(OtherProfileAction)
  case letterSendAction(LetterSendAction)
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
  letterSendReducer
    .pullback(
      state: \.letterSendState,
      action: /ChatDetailAction.letterSendAction,
      environment: {
        LetterSendEnvironment.init(
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
    state.blockUserList = environment.appService.userService.blockUserList
    state.isFirstLoad = false
    return .merge(
      environment.locationManager
        .delegate()
        .map(ChatDetailAction.locationManager),
      environment.locationManager
        .requestLocation()
        .fireAndForget(),
      Effect(value: .joinRoom)
        .eraseToEffect(),
      Effect(value: .getBlockUserList)
        .eraseToEffect(),
      environment.appService.socketService
        .connect(state.roomId)
        .receive(on: environment.mainQueue)
        .map(ChatDetailAction.socket)
        .eraseToEffect()
        .cancellable(id: ChatDetailId())
    )
  case .onDisAppear:
    guard !state.moveToOtherView else { return .none }
    return environment.appService.socketService
      .disconnect(state.roomId)
      .eraseToEffect()
      .fireAndForget()
  // MARK: Socket
  case let .sendMessage(chat):
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
    guard let userId = user?.id else { return .none }
    state.otherProfileState = OtherProfileState(userId: userId)
    return .none
  // MARK: API Request
  case .getBlockUserList:
    return environment.appService.userService
      .getBlockUserList()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.responseBlockUserList)
  case let .selectQuestionDetail(chatId):
    state.route = nil
    return environment.appService.questionService
      .getQuestionDetailAtChat(chatId: chatId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.responseQuestionDetail)
  case let .selectSendLetter(user):
    state.moveToOtherView = true
    state.letterSendState = LetterSendState(sendingUser: user)
    state.route = .sendLetter
    return .none
  case .joinRoom:
    return environment.appService.roomService
      .joinRoom(roomId: state.roomId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.responseJoinRoom)
  case .selectAlarm:
    return environment.appService.roomService
      .roomAlarm(roomId: state.roomId)
      .throttle(for: 1, scheduler: environment.mainQueue, latest: true)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatDetailAction.responseAlarm)
  // MARK: API Result
  case let .responseJoinRoom(.success(res)):
    if let res = res {
      state.isAlarmOn = res.iAlarm ?? false
      state.currentRoom = res
      state.chatMenuState.roomInfo = res
      state.chatMenuState.isFavorite = res.iFavorite ?? false
    }
    
    if let loc = state.currentLocation, environment.locationManager.locationServicesEnabled() {
      return environment.locationManager
        .requestLocation()
        .fireAndForget()
    }
    return .none
  case let .responseQuestionDetail(.success(res)):
    guard let questionId = res?.id else { return .none }
    state.moveToOtherView = true
    state.questionDetailViewState = .init(questionId: questionId)
    state.route = .questionDetail
  case let .responseAlarm(.success(res)):
    guard let alarmOn = res?.isChatAlarmOn, state.isAlarmOn != alarmOn else { return .none }
    state.isAlarmOn = alarmOn
    return .none
  case let .responseBlockUserList(.success(res)):
    state.blockUserList = res ?? []
    return .none
  case .responseJoinRoom(.failure),
      .responseQuestionDetail(.failure),
      .responseAlarm(.failure),
      .responseBlockUserList(.failure):
    return .none
  // MARK: Route
  case .moveToOtherView:
    state.moveToOtherView = true
    return .none
  case let .setLocationToast(isShow):
    state.showLocationToast = isShow
    return .none
  case let .setRoute(route):
    state.moveToOtherView = true
    state.route = route
    return .none
  // MARK: Location
  case let .locationManager(.didUpdateLocations(locations)):
    guard let loc = locations.first?.rawValue.coordinate else { return .none }
    state.currentLocation = loc
    
    return Effect(value: .checkLocationWithinRadius(loc))
      .eraseToEffect()
  case let .checkLocationWithinRadius(loc):
    let isWithinRadius = state.currentRoom.geofenceRegion.contains(loc)
    if state.isFristGetLocation || state.isWithinRadius != isWithinRadius {
      state.isFristGetLocation = false
      state.isWithinRadius = isWithinRadius
      print("무엇이 문제지", isWithinRadius)
      state.showLocationToast = true
    }
    return .none
  // MARK: OtherProfile Completion
  case let .setOtherProfileAction(completionAction):
    switch completionAction {
    case .block, .unblock:
      state.blockUserList = environment.appService
        .userService
        .blockUserList
    default:
      break
    }
    
    return .none
  default:
    return .none
  }
  
  return .none
}
