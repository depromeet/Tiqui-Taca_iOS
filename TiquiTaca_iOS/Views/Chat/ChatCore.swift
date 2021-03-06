//
//  ChatCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture
import ComposableCoreLocation
import TTNetworkModule
import SwiftUI

struct ChatState: Equatable {
  enum Route {
    case chatDetail
    case none
  }
  
  var route: Route?
  
  var enteredRoom: RoomInfoEntity.Response?
  var lastChatLog: ChatLogEntity.Response?
  var lastLoadTime: String = Date.current(type: .HHmm)
  var unReadChatCount: Int = 0
  
  var currentTab: RoomListType = .like
  var likeRoomList: [RoomInfoEntity.Response] = []
  var popularRoomList: [RoomInfoEntity.Response] = []
  
  var showRoomEnterPopup: Bool = false
  var moveToChatDetail: Bool = false
  
  var willEnterRoom: RoomInfoEntity.Response?
  var chatDetailState: ChatDetailState = .init(roomId: "")
}

enum ChatAction: Equatable {
  case onAppear
  // MARK: Request Action
  case fetchEnteredRoomInfo
  case fetchLikeRoomList
  case fetchPopularRoomList
  // MARK: Socket Action
  case socketConnected(String)
  case socketDisconnected(String)
  case socketResponse(SocketBannerService.Action)
  // MARK: Response Action
  case responsePopularRoomList(Result<[RoomInfoEntity.Response]?, HTTPError>)
  case responseLikeRoomList(Result<[RoomInfoEntity.Response]?, HTTPError>)
  case responseEnteredRoom(Result<RoomInfoEntity.Response?, HTTPError>)
  case responseRoomFavorite(Result<RoomLikeEntity.Response?, HTTPError>)
  // MARK: User Action
  case tabChange(RoomListType)
  case removeFavoriteRoom(RoomInfoEntity.Response)
  case willEnterRoom(RoomInfoEntity.Response)
  case refresh
  // MARK: Router Action
  case setRoute(ChatState.Route?)
  case setShowRoomEnterPopup(Bool)
  case setMoveToChatDetail(Bool)
  // MARK: Child Action
  case chatDetailAction(ChatDetailAction)
}

struct ChatEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var locationManager: LocationManager
}

let chatReducer = Reducer<
  ChatState,
  ChatAction,
  ChatEnvironment
>.combine([
  chatDetailReducer
    .pullback(
      state: \.chatDetailState,
      action: /ChatAction.chatDetailAction,
      environment: {
        ChatDetailEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue,
          locationManager: $0.locationManager
        )
      }
    ),
  chatCore
])

struct TimerId: Hashable { }
struct ChatBannerId: Hashable { }

let chatCore = Reducer<
  ChatState,
  ChatAction,
  ChatEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    state.lastLoadTime = Date.current(type: .HHmm)
    return .merge(
      Effect(value: .fetchEnteredRoomInfo)
        .eraseToEffect(),
      Effect(value: .fetchLikeRoomList)
        .eraseToEffect(),
      Effect(value: .fetchPopularRoomList)
        .eraseToEffect()
    )
  // MARK: Requeset
  case .fetchEnteredRoomInfo:
    return environment.appService.roomService
      .getEnteredRoom()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatAction.responseEnteredRoom)
  case .fetchLikeRoomList:
    return environment.appService.roomService
      .getLikeRoomList()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatAction.responseLikeRoomList)
  case .fetchPopularRoomList:
    return environment.appService.roomService
      .getPopularRoomList()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatAction.responsePopularRoomList)
  case .removeFavoriteRoom(let room):
    return environment.appService.roomService
      .registLikeRoom(roomId: room.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatAction.responseRoomFavorite)
  // MARK: Response
  case let .responseRoomFavorite(.success(res)):
    return Effect(value: .fetchLikeRoomList)
      .eraseToEffect()
  case let .responseEnteredRoom(.success(res)):
    let preEnteredRoom = state.enteredRoom
    state.unReadChatCount = 0
    state.enteredRoom = res
    state.lastChatLog = res?.lastChat
    if let roomId = res?.id {
      state.unReadChatCount = res?.notReadChatCount ?? 0
      if environment.appService.socketBannerService.alreadyConnected(roomId: roomId) {
        return .none
      } else {
        return .merge(
          Effect(value: .socketDisconnected(preEnteredRoom?.id ?? ""))
            .eraseToEffect(),
          Effect(value: .socketConnected(roomId))
            .eraseToEffect()
        )
      }
    } else {
      return environment.appService.socketBannerService
        .bannerDisconnect(preEnteredRoom?.id ?? "")
        .eraseToEffect()
        .fireAndForget()
    }
  case let .responseLikeRoomList(.success(res)):
    state.likeRoomList = res ?? []
    return .none
  case let .responsePopularRoomList(.success(res)):
    state.popularRoomList = res ?? []
    return .none
    // MARK: Socket
  case let .socketConnected(roomId):
    return environment.appService.socketBannerService
      .bannerConnect(roomId)
      .receive(on: environment.mainQueue)
      .map(ChatAction.socketResponse)
      .eraseToEffect()
      .cancellable(id: ChatBannerId())
  case let .socketDisconnected(roomId):
    return environment.appService.socketBannerService
      .bannerDisconnect(roomId)
      .eraseToEffect()
      .fireAndForget()
  case let .socketResponse(.newMessage(message)):
    state.lastChatLog = message
    state.unReadChatCount += 1
    return .none
  case .responseEnteredRoom(.failure),
      .responseLikeRoomList(.failure),
      .responsePopularRoomList(.failure),
      .responseRoomFavorite(.failure):
    return .none
  // MARK: View Action
  case .tabChange(let type):
    guard state.currentTab != type else { return .none }
    state.currentTab = type
    return .none
  case .willEnterRoom(let room):
    guard let roomId = room.id else { return .none }
    state.chatDetailState = ChatDetailState(roomId: roomId)
    state.willEnterRoom = room
    return .none
  case let .setRoute(route):
    state.route = route
    if route == .chatDetail {
      state.moveToChatDetail = true
    }
    return .none
  case let .setShowRoomEnterPopup(isPresented):
    state.showRoomEnterPopup = isPresented
    return .none
  case let .setMoveToChatDetail(isMoveToChatDetail):
    state.route = isMoveToChatDetail ? .chatDetail : ChatState.Route.none
    state.moveToChatDetail = isMoveToChatDetail
    return .none
  case .refresh:
    state.lastLoadTime = Date.current(type: .HHmm)
    return .merge(
      Effect(value: .fetchLikeRoomList)
        .eraseToEffect(),
      Effect(value: .fetchPopularRoomList)
        .eraseToEffect()
    )
  case .chatDetailAction:
    return .none
  }
}
