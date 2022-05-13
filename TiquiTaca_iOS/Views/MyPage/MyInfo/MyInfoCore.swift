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
  var createdAt = Date()
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
  
  case getProfileInfo
  case getProfileInfoResponse(Result<ProfileEntity.Response?, HTTPError>)
}

struct MyInfoEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myInfoReducer = Reducer<
  MyInfoState,
  MyInfoAction,
  MyInfoEnvironment
> { state, action, environment in
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
  case .getProfileInfo:
    return environment.appService.userService
      .getProfile()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyInfoAction.getProfileInfoResponse)
  case let .getProfileInfoResponse(.success(response)):
    state.nickname = response?.nickname ?? ""
//    state.phoneNumber = response?.phoneNumber ?? ""
    let createdDateString = response?.createdAt ?? ""
    let dateFormatter = ISO8601DateFormatter()
    let createdDate = dateFormatter.date(from: createdDateString)
    state.createdAt = createdDate ??  Date()
  }
}
