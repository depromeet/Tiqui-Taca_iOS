//
//  ChatCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture
import TTNetworkModule
import SwiftUI

struct ChatState: Equatable {
  var currentTab: RoomListType = .like
  var isFirstLoad = true
  var willEnterRoomInfo: RoomInfoEntity.Response?
	
  var lastLoadTime: String = Date.current(type: .HHmm)
  var enteredRoom: RoomInfoEntity.Response?
  var likeRoomList: [RoomInfoEntity.Response] = []
  var popularRoomList: [RoomInfoEntity.Response] = []
  
  var chatDetailState: ChatDetailState = .init()
}

enum ChatAction: Equatable {
  case onAppear
  case fetchEnteredRoomInfo
  case fetchLikeRoomList
  case fetchPopularRoomList
  
  case responsePopularRoomList(Result<[RoomInfoEntity.Response]?, HTTPError>)
  case responseLikeRoomList(Result<[RoomInfoEntity.Response]?, HTTPError>)
  case responseEnteredRoom(Result<RoomInfoEntity.Response?, HTTPError>)
  
  case tabChange(RoomListType)
  case removeFavoriteRoom(RoomInfoEntity.Response)
  case enterRoomPopup(RoomInfoEntity.Response)
  case dismissPopup
  case refresh
  
  case chatDetailAction(ChatDetailAction)
}

struct ChatEnvironment {
	let appService: AppService
	let mainQueue: AnySchedulerOf<DispatchQueue>
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
          mainQueue: $0.mainQueue
        )
      }
    ),
  chatCore
])

let chatCore = Reducer<
  ChatState,
  ChatAction,
  ChatEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    guard state.isFirstLoad else { return .none }
    
    state.lastLoadTime = Date.current(type: .HHmm)
    state.isFirstLoad = true
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
    return .none
    // MARK: Response
  case let .responseEnteredRoom(.success(res)):
    state.enteredRoom = res
    return .none
  case let .responseLikeRoomList(.success(res)):
    state.likeRoomList = res ?? []
    return .none
  case let .responsePopularRoomList(.success(res)):
    state.popularRoomList = res ?? []
    return .none
  case .responseEnteredRoom(.failure),
      .responseLikeRoomList(.failure),
      .responsePopularRoomList(.failure):
    return .none
    // MARK: View Action
  case .tabChange(let type):
    guard state.currentTab != type else { return .none }
    state.currentTab = type
    return .none
  case .enterRoomPopup(let room):
    state.willEnterRoomInfo = room
    return .none
  case .dismissPopup:
    state.willEnterRoomInfo = nil
    return .none
  case .refresh:
    state.lastLoadTime = Date.current(type: .HHmm)
    return .merge(
      Effect(value: .fetchEnteredRoomInfo)
        .eraseToEffect(),
      Effect(value: .fetchLikeRoomList)
        .eraseToEffect(),
      Effect(value: .fetchPopularRoomList)
        .eraseToEffect()
    )
  case .chatDetailAction:
    return .none
  }
}

