//
//  MyPageCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import ComposableArchitecture

struct MyPageState: Equatable {
  var nickName = ""
  var profileImage = "defaultProfile"
  var createdAt = ""
  var createDday = ""
  var isAppAlarmOn = false
  var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  var popupPresented = false
}

enum MyPageAction: Equatable {
	case selectDetail
  case dismissDetail
}

struct MyPageEnvironment { }

let myPageReducer = Reducer<
	MyPageState,
	MyPageAction,
	MyPageEnvironment
> { state, action, environment in
  switch action {
  case .selectDetail:
    state.popupPresented = true
    return .none
  case .dismissDetail:
    state.popupPresented = false
    return .none
  }
  
	return .none
}
