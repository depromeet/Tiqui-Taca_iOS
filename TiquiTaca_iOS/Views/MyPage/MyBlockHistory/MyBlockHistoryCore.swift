//
//  MyBlockHistoryCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import ComposableArchitecture

struct MyBlockHistoryState: Equatable {
  var blockListView: BlockListState = .init(
    blockUsers: [
      .init(userId: "1", nickName: "닉네임1", profile: "1"),
      .init(userId: "2", nickName: "닉네임2", profile: "2"),
    ]
  )
  var popupPresented: Bool = false
}

struct BlockUser: Equatable, Identifiable {
  var id = UUID()
  var userId: String
  var nickName: String
  var profile: String
}

enum MyBlockHistoryAction: Equatable {
  case releaseBlock(String)
  case popupPresent
  case blockListView(BlockListAction)
}

struct MyBlockHistoryEnvironment {
}

let myBlockHistoryReducer = Reducer<
  MyBlockHistoryState,
  MyBlockHistoryAction,
  MyBlockHistoryEnvironment
>.combine([
  blockListReducer
    .pullback(
      state: \.blockListView,
      action: /MyBlockHistoryAction.blockListView,
      environment: { _ in
        BlockListEnvironment()
      }
    ),
  myBlockHistoryReducerCore
])

let myBlockHistoryReducerCore = Reducer<
  MyBlockHistoryState,
  MyBlockHistoryAction,
  MyBlockHistoryEnvironment
> { state, action, _ in
  switch action {
  case let .releaseBlock(id):
    return .none
  case .popupPresent:
    return .none
  case .blockListView:
    return .none
  }
}
