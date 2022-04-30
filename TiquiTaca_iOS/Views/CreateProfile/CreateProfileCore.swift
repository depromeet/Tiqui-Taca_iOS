//
//  CreateProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import ComposableArchitecture

struct CreateProfileState: Equatable {
  var nickname: String
  var profileImage: ProfileCharacterState = .init(
    characterImage: "defaultProfile")
}

enum CreateProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case profileCharacterView(ProfileCharacterAction)
}

struct CreateProfileEnvironment {
}

let createProfileReducer = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
>.combine([
  profileCharacterReducer
    .pullback(
      state: \.profileImage,
      action: /CreateProfileAction.profileCharacterView,
      environment: { _ in
        ProfileCharacterEnvironment()
      }
    ),
  createProfileReducerCore
])

let createProfileReducerCore = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
> { state, action, _ in
  switch action {
  case .doneButtonTapped:
    return .none
  case let .nicknameChanged(nickname):
    state.nickname = nickname
    _ = Effect<ProfileCharacterAction, Never>(value: ProfileCharacterAction.nicknameChanged)
    return .none
  case .profileCharacterView(_):
    return .none
  }
}
