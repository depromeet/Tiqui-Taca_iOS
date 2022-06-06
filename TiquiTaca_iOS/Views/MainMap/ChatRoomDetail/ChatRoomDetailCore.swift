//
//  ChatRoomDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/06.
//

import CoreLocation
import ComposableArchitecture

struct ChatRoomDetailState: Equatable {
  var chatRoom: RoomFromCategoryResponse = .init()
  var currentLocation: CLLocation = .init(latitude: 0, longitude: 0)
  var isWithinRadius: Bool = false
}

enum ChatRoomDetailAction: Equatable {
  case joinChatRoomButtonTapped
  case checkCurrentLocationWithinRadius
}

struct ChatRoomDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatRoomDetailReducer = Reducer<
  ChatRoomDetailState,
  ChatRoomDetailAction,
  ChatRoomDetailEnvironment
>.combine([
  chatRoomDetailCore
])

let chatRoomDetailCore = Reducer<
  ChatRoomDetailState,
  ChatRoomDetailAction,
  ChatRoomDetailEnvironment
> { state, action, environment in
  switch action {
  case .joinChatRoomButtonTapped:
    return .none
    
  case .checkCurrentLocationWithinRadius:
    let isWithinRadius = state.chatRoom.geofenceRegion.contains(state.currentLocation.coordinate)
    state.isWithinRadius = isWithinRadius
    return .none
  }
}
