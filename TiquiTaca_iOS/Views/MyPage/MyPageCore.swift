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
  var sheetChoice: MyPageSheetChoice?
}

enum MyPageSheetChoice: Hashable, Identifiable {
  case myInfoView
  case blockHistoryView
  case noticeView
  case myTermsOfServiceView
  case csCenterView
  case none
  
  var id: MyPageSheetChoice { self }
}

struct MyPageItem {
  let imageName: String
}

enum MyPageAction: Equatable {
	case selectDetail
  case selectSheet(MyPageSheetChoice)
  case dismissDetail
}

struct MyPageEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myPageReducer = Reducer<
	MyPageState,
	MyPageAction,
	MyPageEnvironment
> { state, action, environment in
  switch action {
  case .selectDetail:
    return .none
  case let .selectSheet(presentedSheet):
    state.sheetChoice = presentedSheet
    state.popupPresented = true
    return .none
  case .dismissDetail:
    state.popupPresented = false
    return .none
  }
}
