//
//  NoticeCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import ComposableArchitecture
import Foundation

struct NoticeState: Equatable {
  var noticeList: [Notice] = []
}

struct Notice: Equatable, Identifiable {
  let id = UUID()
  var title: String
  var writer: String
  var date: String
}

enum NoticeAction: Equatable {
  case getNoticeList
}

struct NoticeEnvironment: Equatable {
}

let noticeReducer = Reducer<
  NoticeState,
  NoticeAction,
  NoticeEnvironment
> { state, action, environment in
  switch action {
  case .getNoticeList:
    return .none
  }
}
