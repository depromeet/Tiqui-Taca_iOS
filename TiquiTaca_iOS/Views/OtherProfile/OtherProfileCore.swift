//
//  OtherProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/07.
//

import Combine
import ComposableArchitecture
import TTNetworkModule

struct OtherProfileState: Equatable {
  var otherUser: UserEntity.Response?
}

enum OtherProfileAction: Equatable {
  case onAppear
  
}

struct OtherProfileEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let otherProfileReducer = Reducer<
  OtherProfileState,
  OtherProfileAction,
  OtherProfileEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
