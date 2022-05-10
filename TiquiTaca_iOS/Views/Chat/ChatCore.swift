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
	
	var enteredRoom: RoomInfoEntity.Response?
	var likeRoomList: [RoomInfoEntity.Response] = []
	var popularRoomList: [RoomInfoEntity.Response] = []
	var presentRoomList: [RoomInfoEntity.Response] = []
}

enum ChatAction: Equatable {
	case tabChange(RoomListType)
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
	case .tabChange(let type):
		guard state.currentTab != type else { return .none }
		state.currentTab = type
		state.presentRoomList = type == .like ? state.likeRoomList : state.popularRoomList
		return .none
	case .refresh:
		
		return .none
	}
}
