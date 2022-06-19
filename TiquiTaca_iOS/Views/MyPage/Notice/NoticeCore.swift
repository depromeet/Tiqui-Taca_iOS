//
//  NoticeCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import ComposableArchitecture
import Foundation
import TTNetworkModule

struct NoticeState: Equatable {
  var noticeList: [OfficialNotiResponse] = []
}

enum NoticeAction: Equatable {
  case getNoticeList
  case getNoticeResponse(Result<[OfficialNotiResponse]?, HTTPError>)
}

struct NoticeEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let noticeReducer = Reducer<
  NoticeState,
  NoticeAction,
  NoticeEnvironment
> { state, action, environment in
  switch action {
  case .getNoticeList:
    return environment.appService.userService
      .getOfficialNoti()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(NoticeAction.getNoticeResponse)
  case let .getNoticeResponse(.success(response)):
    guard let response = response else { return .none }
    state.noticeList = response
    return .none
  case .getNoticeResponse(.failure):
    return .none
  }
}
