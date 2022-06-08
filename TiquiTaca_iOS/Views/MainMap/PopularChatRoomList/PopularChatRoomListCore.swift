//
//  PopularChatRoomListCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import ComposableArchitecture
import ComposableCoreLocation
import TTNetworkModule

struct PopularChatRoomListState: Equatable {
  var popularList: [RoomFromCategoryResponse] = []
  var isLoading: Bool = false
  var currentLocation: CLLocation = .init(latitude: 0, longitude: 0)
}

enum PopularChatRoomListAction: Equatable {
  case itemSelected(RoomFromCategoryResponse)
  case getRoomListResponse(Result<[RoomFromCategoryResponse]?, HTTPError>)
  case requestChatRoomList
  case setLoading(Bool)
}

struct PopularChatRoomListEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
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
  case let .setLoading(isLoading):
    state.isLoading = isLoading
    return .none
    
  case .itemSelected:
    return .none
    
  case .requestChatRoomList:
    let request = RoomFromCategoryRequest(
      latitude: state.currentLocation.coordinate.latitude,
      longitude: state.currentLocation.coordinate.longitude,
      filter: .all,
      radius: 1000000
    )
    return .concatenate([
      .init(value: .setLoading(true)),
      environment.appService.roomService
        .getRoomList(request)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(PopularChatRoomListAction.getRoomListResponse)
      ,
      .init(value: .setLoading(false))
    ])
    
  case let .getRoomListResponse(.success(response)):
    guard let roomList = response else { return .none }
    let sortedList = (roomList.sorted { $0.userCount > $1.userCount })
    state.popularList = Array(sortedList[safe: 0..<3])
    return .none
    
  case .getRoomListResponse(.failure):
    return .none
  }
}
