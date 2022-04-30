//
//  ProfileCharacterViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import ComposableArchitecture

struct ProfileCharacterState: Equatable {
  var characterImage: String
  var isSheetPresented = false
  var nicknameFocused = false
}

enum ProfileCharacterAction: Equatable {
  case characterImageChanged(String)
  case editButtonTapped
  case dismissProfileDetail
  case nicknameChanged
}

struct ProfileCharacterEnvironment {
}

let profileCharacterReducer = Reducer<
  ProfileCharacterState,
  ProfileCharacterAction,
  ProfileCharacterEnvironment
> { state, action, environment in
  switch action {
  case let .characterImageChanged(imageString):
    state.characterImage = imageString
    return .none
  case .editButtonTapped:
    state.isSheetPresented = true
    return .none
  case .dismissProfileDetail:
    state.isSheetPresented = false
    return .none
  case .nicknameChanged:
    state.isSheetPresented = false
    state.nicknameFocused = true
    return .none
  }
}
