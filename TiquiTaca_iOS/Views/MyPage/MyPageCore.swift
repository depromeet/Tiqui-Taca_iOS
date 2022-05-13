//
//  MyPageCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import ComposableArchitecture
import TTNetworkModule
import Foundation

struct MyPageState: Equatable {
  var nickname = "닉네임"
  var profileImage = "defaultProfile"
  var level = 1
  var createdAt = Date()
  var createDday = 0
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
  case getProfileInfo
  case getProfileInfoResponse(Result<ProfileEntity.Response?, HTTPError>)
  case getProfileRequestSuccess
  
  case alarmToggle
  case getAlarmRequestResponse(Result<AppAlarmEntity.Response?, HTTPError>)
  case getAlarmRequestSuccess
  
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
  case .getProfileInfo:
    return environment.appService.userService
      .getProfile()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyPageAction.getProfileInfoResponse)
  case let .getProfileInfoResponse(.success(response)):
//    state.profileImage = response?.profile.type
    state.nickname = response?.nickname ?? ""
    state.isAppAlarmOn = response?.appAlarm ?? false
    state.level = response?.level ?? 0
    
    let createdDateString = response?.createdAt ?? ""
    let dateFormatter = ISO8601DateFormatter()
    let createdDate = dateFormatter.date(from: createdDateString)
    state.createdAt = createdDate ?? Date()
    state.createDday = Calendar(identifier: .gregorian)
      .dateComponents([.day], from: createdDate ?? Date(), to: Date()).day ?? 0
    
    return Effect(value: .getProfileRequestSuccess)
  case .getProfileInfoResponse(.failure):
    return .none
  case .getProfileRequestSuccess:
    return .none
    
  case .alarmToggle:
    return environment.appService.userService
      .getAppAlarmState()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyPageAction.getAlarmRequestResponse)
  case let .getAlarmRequestResponse(.success(response)):
    state.isAppAlarmOn = response?.appAlarm ?? false
    return Effect(value: .getProfileRequestSuccess)
  case .getAlarmRequestResponse(.failure):
    return .none
  case .getAlarmRequestSuccess:
    return .none
    
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
