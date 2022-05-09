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
  var popupPresented = false
  var popupType: MyInfoPopupType = .logout
  
  enum MyInfoPopupType {
    case logout
    case withdrawal
  }
}


enum MyInfoAction: Equatable {
  case changeNickname
  case logoutAction
  case withDrawalAction
  case presentPopup
  case dismissPopup
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
    state.popupPresented = true
    state.popupType = .logout
    return .none
  case .withDrawalAction:
    state.popupPresented = true
    state.popupType = .withdrawal
    return .none
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  }
}
