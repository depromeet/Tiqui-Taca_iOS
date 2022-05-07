//
//  BlockListCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import ComposableArchitecture

struct BlockListState: Equatable {
  var blockUsers: [BlockUser]
  var isPopupPresented = false
  var unblockUserId: String = ""
}

enum BlockListAction: Equatable {
  case selectDetail(String)
  case dismissBlockDetail
}

struct BlockListEnvironment: Equatable { }

let blockListReducer = Reducer<
  BlockListState,
  BlockListAction,
  BlockListEnvironment
> { state, action, environment in
  switch action {
  case .selectDetail(let userId):
    state.unblockUserId = userId
    state.isPopupPresented = true
    return .none
  case .dismissBlockDetail:
    state.isPopupPresented = false
    return .none
  }
}
