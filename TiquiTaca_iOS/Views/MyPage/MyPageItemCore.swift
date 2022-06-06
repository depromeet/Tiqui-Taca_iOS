//
//  MyPageItemCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/06.
//

import ComposableArchitecture
import TTNetworkModule
import Foundation

struct MyPageItemState: Equatable, Identifiable {
  let id: UUID = UUID()
  var rowInfo: MyPageItemInfo?
  var isAppAlarmOn: Bool = false
}

enum MyPageItemAction: Equatable {
  case alarmToggle
  case getAlarmRequestResponse(Result<AppAlarmEntity.Response?, HTTPError>)
  case getAlarmRequestSuccess
}

struct MyPageItemEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myPageItemReducer = Reducer<
  MyPageItemState,
  MyPageItemAction,
  MyPageItemEnvironment
> { state, action, environment in
  switch action {
  case .alarmToggle:
    return environment.appService.userService
      .getAppAlarmState()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyPageItemAction.getAlarmRequestResponse)
    
  case let .getAlarmRequestResponse(.success(response)):
    state.isAppAlarmOn = response?.appAlarm ?? false
    return .none
    
  case .getAlarmRequestResponse(.failure):
    return .none
    
  case .getAlarmRequestSuccess:
    return .none
  }
}
