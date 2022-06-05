//
//  ChatRoomListCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/05.
//

import ComposableArchitecture
import ComposableCoreLocation
import TTNetworkModule

struct ChatRoomListState: Equatable {
  var listSortType: ChatRoomListSortType = .distance
  var listCategoryType: LocationCategory = .favorite
  var chatRoomList: [RoomFromCategoryResponse] = []
  var isLoading: Bool = false
  var currentLocation: CLLocation = .init(latitude: 0, longitude: 0)
}

enum ChatRoomListAction: Equatable {
  case setListSortType(ChatRoomListSortType)
  case setListCategoryType(LocationCategory)
  case itemSelected(RoomFromCategoryResponse)
  case getRoomListResponse(Result<[RoomFromCategoryResponse]?, HTTPError>)
  case requestChatRoomList
  case setLoading(Bool)
  case deleteItem(IndexSet)
}

struct ChatRoomListEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatRoomListReducer = Reducer<
  ChatRoomListState,
  ChatRoomListAction,
  ChatRoomListEnvironment
>.combine([
  chatRoomListCore
])

let chatRoomListCore = Reducer<
  ChatRoomListState,
  ChatRoomListAction,
  ChatRoomListEnvironment
> { state, action, environment in
  switch action {
  case let .setListSortType(type):
    if state.listSortType == type { return .none }
    state.listSortType = type
    return sortChatRoomList(&state)
    
  case let .setListCategoryType(category):
    state.listCategoryType = category
    return Effect(value: .requestChatRoomList)
    
  case .itemSelected:
    return .none
    
  case let .getRoomListResponse(.success(response)):
    guard let roomList = response else { return .none }
    state.chatRoomList = roomList
    return sortChatRoomList(&state)
    
  case .getRoomListResponse(.failure):
    return .none
    
  case .requestChatRoomList:
    let request = RoomFromCategoryRequest(
      latitude: state.currentLocation.coordinate.latitude,
      longitude: state.currentLocation.coordinate.longitude,
      filter: state.listCategoryType,
      radius: 10000
    )
    return .concatenate([
      .init(value: .setLoading(true)),
      environment.appService.roomService
        .getRoomList(request)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(ChatRoomListAction.getRoomListResponse)
      ,
      .init(value: .setLoading(false))
    ])
    
  case let .setLoading(isLoading):
    state.isLoading = isLoading
    return .none
    
  case let .deleteItem(offsets):
    state.chatRoomList.remove(atOffsets: offsets)
    return .none
  }
}

private func sortChatRoomList(_ state: inout ChatRoomListState) -> Effect<ChatRoomListAction, Never> {
  switch state.listSortType {
  case .distance:
    state.chatRoomList = state.chatRoomList.sorted {
      $0.distance(from: state.currentLocation) < $1.distance(from: state.currentLocation)
    }
  case .popular:
    state.chatRoomList = state.chatRoomList.sorted {
      $0.userCount > $1.userCount
    }
  }
  return .none
}
