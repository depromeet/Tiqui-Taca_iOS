//
//  ChatCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct ChatState: Equatable {
	var currentTab: RoomListType = .like
	var isFirstLoad = true
	var popupPresented = false
	var willEnterRoomInfo: RoomInfoEntity.Response?
	
	var enteredRoom: RoomInfoEntity.Response?
	var likeRoomList: [RoomInfoEntity.Response] = [RoomInfoEntity.Response()]
	var popularRoomList: [RoomInfoEntity.Response] = []
	var presentRoomList: [RoomInfoEntity.Response] = [RoomInfoEntity.Response()]
}

enum ChatAction: Equatable {
	case fetchEnteredRoomInfo
	case fetchLikeRoomList
	case fetchPopularRoomList
	case tabChange(RoomListType)
	case removeFavoriteRoom(RoomInfoEntity.Response)
	case presentEnterRoomPopup(RoomInfoEntity.Response)
	case dismissPopup
	case refresh
}

struct ChatEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatReducer = Reducer<
	ChatState,
	ChatAction,
	ChatEnvironment
> { state, action, _ in
	switch action {
	case .fetchEnteredRoomInfo:
		return .none
	case .fetchLikeRoomList:
		return .none
	case .fetchPopularRoomList:
		return .none
	case .tabChange(let type):
		guard state.currentTab != type else { return .none }
		state.currentTab = type
		state.presentRoomList = type == .like ? state.likeRoomList : state.popularRoomList
		return .none
	case .removeFavoriteRoom(let room):
		return .none
	case .presentEnterRoomPopup(let room):
		state.willEnterRoomInfo = room
		state.popupPresented = true
		return .none
	case .dismissPopup:
		state.popupPresented = false
		state.willEnterRoomInfo = nil
		return .none
	case .refresh:
		return .none
	}
}
