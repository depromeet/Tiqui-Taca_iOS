//
//  MyPageCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import ComposableArchitecture
import TTNetworkModule

struct MyPageState: Equatable {
  typealias Route = MyPageItemType
  var route: Route?
  
  var myInfoViewState: MyInfoState = .init()
  var nickname = ""
  var phoneNumber = ""
  var profileImage: ProfileImage = .init()
  var level = 1
  var createdAt: String = ""
  var createDday = 0
  var isAppAlarmOn = false
  var rowInfo: [MyPageItemInfo] = [
    .init(itemType: .myInfoView),
    .init(itemType: .alarmSet, toggleVisible: true),
    .init(itemType: .blockHistoryView),
    .init(itemType: .noticeView),
    .init(itemType: .myTermsOfServiceView),
    .init(itemType: .csCenterView),
    .init(itemType: .versionInfo, description: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
  ]
}

enum MyPageAction: Equatable {
  case setRoute(MyPageState.Route?)
  case myInfoView(MyInfoAction)
  case getProfileInfo
  case getProfileRequestSuccess
  case alarmToggle
  case getAlarmRequestResponse(Result<AppAlarmEntity.Response?, HTTPError>)
  case getAlarmRequestSuccess
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
    let myProfile = environment.appService.userService.myProfile
    state.profileImage.type = myProfile?.profile.type ?? 0
    state.nickname = myProfile?.nickname ?? ""
    state.isAppAlarmOn = myProfile?.appAlarm ?? false
    state.level = myProfile?.level ?? 0
    state.phoneNumber = myProfile?.phoneNumber ?? ""
    
    if var phoneNumber = myProfile?.phoneNumber, phoneNumber.count > 9 {
      phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
      phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.endIndex, offsetBy: -4))
      
      state.phoneNumber = phoneNumber
    }
    
    let createdDateString = myProfile?.createdAt ?? ""
    let iso8601Formatter = ISO8601DateFormatter()
    let createdDate = iso8601Formatter.date(from: createdDateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    state.createdAt = dateFormatter.string(for: createdDate) ?? ""
    state.createDday = Calendar(identifier: .gregorian)
      .dateComponents([.day], from: createdDate ?? Date(), to: Date()).day ?? 0
    
    state.myInfoViewState = .init(nickname: state.nickname, phoneNumber: state.phoneNumber, createdAt: state.createdAt)
    return Effect(value: .getProfileRequestSuccess)
    
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
    
  case .logout:
    return .none
    
  case let .setRoute(route):
    if route == .alarmSet || route == .versionInfo {
      state.route = nil
    } else {
      state.route = route
    }
    return .none
  }
}
