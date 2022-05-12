//
//  CreateProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import ComposableArchitecture

struct CreateProfileState: Equatable {
  var nickname: String = ""
  var profileImage: String = "defaultProfile"
  var isSheetPresented: Bool = false
  var nicknameFocused: Bool = false
}

enum CreateProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case profileImageChanged(String)
  case profileEditButtonTapped
  case setBottomSheet(isPresent: Bool)
}

struct CreateProfileEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let createProfileReducer = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
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
  case let .setBottomSheet(isPresent):
    state.isSheetPresented = isPresent
    return .none
  }
}
