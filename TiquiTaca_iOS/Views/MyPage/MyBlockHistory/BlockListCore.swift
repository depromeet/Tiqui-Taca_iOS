//
//  BlockListCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import ComposableArchitecture

struct BlockListState: Equatable {
  var blockUsers: [BlockUserEntity.Response]
}

enum BlockListAction: Equatable {
  case selectUnblockUser(BlockUserEntity.Response)
  case dismissPopup
}

struct BlockListEnvironment: Equatable { }

let blockListReducer = Reducer<
  BlockListState,
  BlockListAction,
  BlockListEnvironment
> { state, action, environment in
  return .none
}
