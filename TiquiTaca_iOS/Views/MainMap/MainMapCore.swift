//
//  MainMapCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Combine
import ComposableArchitecture

struct MainMapState: Equatable {
	var dummyState = 0
}

enum MainMapAction: Equatable {
  case logout
}

struct MainMapEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let mainMapReducer = Reducer<
  MainMapState,
  MainMapAction,
MainMapEnvironment
> { state, action, environment in
  switch action {
  case .logout:
    return .none
  }
}
