//
//  MainTabCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MainTabState: Equatable {
	// Feature State
	var mapFeature: MapState
	var chatFeature: ChatState
	var msgAndNotiFeature: MsgAndNotiState
	var myPageFeature: MyPageState
}

enum MainTabAction: Equatable {
	// Feature Action
	case mapFeature(MapAction)
	case chatFeature(ChatAction)
	case msgAndNotiFeature(MsgAndNotiAction)
	case myPageFeature(MyPageAction)
}

struct MainTabEnvironment { }

let mainTabReducer = Reducer<
	MainTabState,
	MainTabAction,
	MainTabEnvironment
>.combine(
	mapReducer
		.pullback(
			state: \.mapFeature,
			action: /MainTabAction.mapFeature,
			environment: ({ _ in MapEnvironment() })
		),
	chatReducer
		.pullback(
			state: \.chatFeature,
			action: /MainTabAction.chatFeature,
			environment: ({ _ in ChatEnvironment() })
		),
	msgAndNotiReducer
		.pullback(
			state: \.msgAndNotiFeature,
			action: /MainTabAction.msgAndNotiFeature,
			environment: ({ _ in MsgAndNotiEnvironment() })
		),
	myPageReducer
		.pullback(
			state: \.myPageFeature,
			action: /MainTabAction.myPageFeature,
			environment: ({ _ in MyPageEnvironment() })
		),
	.init { _, _, _ in
		return .none
	}
)
