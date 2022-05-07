//
//  MyPageCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MyPageState: Equatable {
	var dummyState = 0
}

enum MyPageAction: Equatable {
	case dummyAction
}

struct MyPageEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myPageReducer = Reducer<
	MyPageState,
	MyPageAction,
	MyPageEnvironment
> { _, _, _ in
	return .none
}
