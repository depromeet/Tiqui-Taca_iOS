//
//  MapCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MapState: Equatable {
	var dummyState = 0
}

enum MapAction: Equatable {
	case dummyAction
}

struct MapEnvironment { }

let mapReducer = Reducer<
	MapState,
	MapAction,
	MapEnvironment
> { _, _, _ in
	return .none
}
