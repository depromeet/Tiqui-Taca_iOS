//
//  ChangeProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/09.
//

import ComposableArchitecture

struct ChangeProfileState: Equatable {
  var nickname = ""
  var profileImage = "defaultProfile"
  var isSheetPresented = false
  var nicknameFocused = false
}

enum ChangeProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case profileImageChanged(String)
  case profileEditButtonTapped
  case dismissProfileDetail
}

struct ChangeProfileEnvironment {
}

let changeProfileReducer = Reducer<
  ChangeProfileState,
  ChangeProfileAction,
  ChangeProfileEnvironment
> { state, action, environment in
  switch action {
  case .doneButtonTapped:
    return .none
  case let .nicknameChanged(nickname):
    state.nickname = nickname
    state.nicknameFocused = true
    state.isSheetPresented = false
    return .none
  case let .profileImageChanged(imageString):
    state.profileImage = imageString
    return .none
  case .profileEditButtonTapped:
    state.nicknameFocused = false
    state.isSheetPresented = true
    return .none
  case .dismissProfileDetail:
    state.isSheetPresented = true
    return .none
  }
}
