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
}

enum MyPageAction: Equatable {
	case dummyAction
}

struct MyPageEnvironment { }

let myPageReducer = Reducer<
	MyPageState,
	MyPageAction,
	MyPageEnvironment
> { _, _, _ in
	return .none
}
