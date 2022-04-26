//
//  ChatCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct ChatState: Equatable {
	var dummyState = 0
}

enum ChatAction: Equatable {
	case dummyAction
}

struct ChatEnvironment { }

let chatReducer = Reducer<
	ChatState,
	ChatAction,
	ChatEnvironment
> { _, _, _ in
	return .none
}
