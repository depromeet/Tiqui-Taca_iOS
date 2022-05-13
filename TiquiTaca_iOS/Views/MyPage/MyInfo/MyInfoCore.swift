//
//  MyInfoCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import ComposableArchitecture
import TTNetworkModule

struct MyInfoState: Equatable {
  var nickname = "변경하려는 닉네임"
  var phoneNumber = "010-1234-5678"
  var createdAt: String = ""
  var nicknameChanging = false
  var popupPresented = false
  var popupType: MyInfoPopupType = .logout
  var isDismissCurrentView: Bool = false
  var dismissType: MyInfoDismissType = .none
  
  enum MyInfoPopupType {
    case logout
    case withdrawal
  }
}

enum MyInfoDismissType {
  case logout
  case withdrawal
  case none
}

enum MyInfoAction: Equatable {
  case changeNickname
  case presentLogoutPopup
  case presentWithdrawalPopup
  case logoutAction
  case withDrawalAction
  case presentPopup
  case dismissPopup
  case movingAction(MyInfoDismissType)
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
  case .presentLogoutPopup:
    state.popupPresented = true
    state.popupType = .logout
    return .none
  case .presentWithdrawalPopup:
    state.popupPresented = true
    state.popupType = .withdrawal
    return .none
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  case .logoutAction:
    state.isDismissCurrentView = true
    state.dismissType = .logout
    return Effect(value: .dismissPopup)
  case .withDrawalAction:
    state.isDismissCurrentView = true
    state.dismissType = .withdrawal
    return Effect(value: .dismissPopup)
  case let .movingAction(dismissType):
    return .none
  }
}
