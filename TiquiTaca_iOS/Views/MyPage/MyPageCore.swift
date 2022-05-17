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
  var myInfoViewState: MyInfoState = .init()
  var nickname = "닉네임"
  var profileImage: ProfileImage = .init()
  var level = 1
  var createdAt: String = ""
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
  case myInfoView(MyInfoAction)
  
  case getProfileInfo
  case getProfileInfoResponse(Result<ProfileEntity.Response?, HTTPError>)
  case getProfileRequestSuccess
  
  case alarmToggle
  case getAlarmRequestResponse(Result<AppAlarmEntity.Response?, HTTPError>)
  case getAlarmRequestSuccess
  
  case selectDetail
  case selectSheet(MyPageSheetChoice)
  case dismissDetail
  case logout
}

struct MyPageEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myPageReducer = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
>.combine([
  myInfoReducer
    .pullback(
      state: \.myInfoViewState,
      action: /MyPageAction.myInfoView,
      environment: { _ in
        MyInfoEnvironment()
      }
    ),
  myPageReducerCore
])

let myPageReducerCore = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
> { state, action, environment in
  switch action {
  case let .myInfoView(myInfoAction):
    switch myInfoAction {
    case let .movingAction(dismissType):
      if dismissType == .logout {
        return Effect(value: .logout)
      }
      return .none
    default:
      return .none
    }
  case .getProfileInfo:
    return environment.appService.userService
      .getProfile()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyPageAction.getProfileInfoResponse)
    
  case let .getProfileInfoResponse(.success(response)):
    state.profileImage.type = response?.profile.type ?? 0
    state.nickname = response?.nickname ?? ""
    state.isAppAlarmOn = response?.appAlarm ?? false
    state.level = response?.level ?? 0
    
    let createdDateString = response?.createdAt ?? ""
    let iso8601Formatter = ISO8601DateFormatter()
    let createdDate = iso8601Formatter.date(from: createdDateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    state.createdAt = dateFormatter.string(for: createdDate) ?? ""
    state.createDday = Calendar(identifier: .gregorian)
      .dateComponents([.day], from: createdDate ?? Date(), to: Date()).day ?? 0
    
    state.myInfoViewState = .init(nickname: state.nickname, phoneNumber: "", createdAt: state.createdAt)
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
//    if state.sheetChoice == .myInfoView {
//      return Effect(value: .logout)
//    }
    return .none
  case .logout:
    return .none

  }
}
