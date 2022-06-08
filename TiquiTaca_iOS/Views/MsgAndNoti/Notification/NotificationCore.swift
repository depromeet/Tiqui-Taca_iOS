//
//  NotificationCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import ComposableArchitecture

struct NotificationState: Equatable {
}

struct NotificationAction: Equatable {
}

struct NotificationEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let notificationReducer = Reducer<
  NotificationState,
  NotificationAction,
  NotificationEnvironment
>.combine([
  notificationCore
])

let notificationCore = Reducer<
  NotificationState,
  NotificationAction,
  NotificationEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
