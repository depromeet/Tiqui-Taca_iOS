//
//  MsgAndNotiCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MsgAndNotiState: Equatable {
	var dummyState = 0
  //임시 처리
  var letterList: [String] = []
  var noticeList: [String] = []
  var selectedTab = 0
}


enum MsgAndNotiAction: Equatable {
	case dummyAction
  case selectTab(Int)
}

struct MsgAndNotiEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let msgAndNotiReducer = Reducer<
	MsgAndNotiState,
	MsgAndNotiAction,
	MsgAndNotiEnvironment
> { state, action, environment in
  switch action {
  case .dummyAction:
    return .none
  case let .selectTab(tabIndex):
    state.selectedTab = tabIndex
    return .none
  }
	return .none
}
