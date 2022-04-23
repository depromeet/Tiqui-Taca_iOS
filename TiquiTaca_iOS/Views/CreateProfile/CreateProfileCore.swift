//
//  CreateProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import ComposableArchitecture

struct CreateProfileState: Equatable {
  var nickname: String
}

enum CreateProfileAction: Equatable {
  case doneButtonTapped
}

struct CreateProfileEnvironment {
}

let createProfileReducer = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
>.combine([
  createProfileReducerCore
])

let createProfileReducerCore = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
> { state, action, environment in
  switch action {
  case .doneButtonTapped:
    return .none
  }
}
