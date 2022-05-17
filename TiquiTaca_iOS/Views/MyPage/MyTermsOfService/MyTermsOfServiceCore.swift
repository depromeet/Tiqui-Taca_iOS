//
//  MyTermsOfServiceCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import ComposableArchitecture
import Foundation

struct MyTermsOfServiceState: Equatable {
  var noticeList: [Notice] = []
}

enum MyTermsOfServiceAction: Equatable {
  case getNoticeList
}

struct MyTermsOfServiceEnvironment: Equatable {
}

let myTermsOfServiceReducer = Reducer<
  MyTermsOfServiceState,
  MyTermsOfServiceAction,
  MyTermsOfServiceEnvironment
> { state, action, environment in
  switch action {
  case .getNoticeList:
    return .none
  }
}
