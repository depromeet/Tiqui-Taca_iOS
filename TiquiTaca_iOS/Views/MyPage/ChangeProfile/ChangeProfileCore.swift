//
//  ChangeProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/09.
//
import SwiftUI
import ComposableArchitecture

struct ChangeProfileState: Equatable {
  var nickname = ""
  var profileImage = "defaultProfile"
  var isSheetPresented = false
  var nicknameFocused: NicknameState = .unfocused
  
  enum NicknameState {
    case focused
    case unfocused
    case error
    
    var color: Color {
      switch self {
      case .focused:
        return .green500
      case .unfocused:
        return .white700
      case .error:
        return .errorRed
      }
    }
  }
}


enum ChangeProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case nicknameFocused
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
    return .none
  case .nicknameFocused:
    state.nicknameFocused = .focused
    state.isSheetPresented = false
    return .none
  case let .profileImageChanged(imageString):
    state.profileImage = imageString
    return .none
  case .profileEditButtonTapped:
    state.nicknameFocused = .unfocused
    state.isSheetPresented = true
    return .none
  case .dismissProfileDetail:
    state.isSheetPresented = true
    return .none
  }
}
