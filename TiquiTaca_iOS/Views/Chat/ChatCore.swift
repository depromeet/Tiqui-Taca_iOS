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
	var currentTabIdx = 0
}

enum ChatAction: Equatable {
	case tabChange(Int)
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
	case .tabChange(let tabIdx):
		guard state.currentTabIdx != tabIdx else { return .none }
		state.currentTabIdx = tabIdx
		print("change TabIdx: \(tabIdx)")
		return .none
	}
}
