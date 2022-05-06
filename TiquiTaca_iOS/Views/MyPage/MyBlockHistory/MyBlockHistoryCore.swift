//
//  MyBlockHistoryCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import ComposableArchitecture

struct MyBlockHistoryState: Equatable {
  var blockUsers: [BlockUser] = [BlockUser(userId: "", nickName: "hakyung", profile: "1")]//.init()
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
}

struct MyBlockHistoryEnvironment {
}

let myBlockHistoryReducer = Reducer<
  MyBlockHistoryState,
  MyBlockHistoryAction,
  MyBlockHistoryEnvironment
> { state, action, _ in
  switch action {
  case let .releaseBlock(id):
    return .none
  }
}
