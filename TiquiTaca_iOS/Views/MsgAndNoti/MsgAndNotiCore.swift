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
}

enum MsgAndNotiAction: Equatable {
	case dummyAction
}

struct MsgAndNotiEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let msgAndNotiReducer = Reducer<
	MsgAndNotiState,
	MsgAndNotiAction,
	MsgAndNotiEnvironment
> { _, _, _ in
	return .none
}
