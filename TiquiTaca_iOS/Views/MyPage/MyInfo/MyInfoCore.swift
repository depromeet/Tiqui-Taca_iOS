//
//  MyInfoCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import ComposableArchitecture

struct MyInfoState: Equatable {
  var nickName = "변경하려는 닉네임"
  var phoneNumber = "010-1234-5678"
  var createdAt = "2022.04.05"
  var nicknameChanging = false
}

enum MyInfoAction: Equatable {
  case changeNickname
  case logoutAction
  case withDrawalAction
}

struct MyInfoEnvironment { }

let myInfoReducer = Reducer<
  MyInfoState,
  MyInfoAction,
  MyInfoEnvironment
> { state, action, _ in
  switch action {
  case .changeNickname:
    state.nicknameChanging.toggle()
    return .none
  case .logoutAction:
    return .none
  case .withDrawalAction:
    return .none
  }
}
