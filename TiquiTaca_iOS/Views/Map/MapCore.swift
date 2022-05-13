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
  case logout
}

struct MapEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let mapReducer = Reducer<
	MapState,
	MapAction,
	MapEnvironment
> { state, action, environment in
  switch action {
  case .logout:
    return .none
  }
}
