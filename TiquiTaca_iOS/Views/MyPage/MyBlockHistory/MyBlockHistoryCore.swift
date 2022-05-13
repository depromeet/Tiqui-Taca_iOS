//
//  MyBlockHistoryCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import ComposableArchitecture
import TTNetworkModule

struct MyBlockHistoryState: Equatable {
  var blockListView: BlockListState = .init(
    blockUsers: []
  )
  var popupPresented = false
  var unBlockUser: BlockUserEntity.Response?
}

enum MyBlockHistoryAction: Equatable {
  case releaseBlock(String)
  case presentPopup
  case dismissPopup
  case blockListView(BlockListAction)
  
  case getBlockUserList
  case getBlockUserListResponse(Result<[BlockUserEntity.Response]?, HTTPError>)
  case getBlockUserRequestSuccess
  
  case unblockUser(String)
  case unblockUserResponse(Result<BlockUserEntity.Response?, HTTPError>)
  case unblockUserRequestSuccess
}

struct MyBlockHistoryEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
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
> { state, action, environment in
  switch action {
  case let .releaseBlock(id):
    return .none
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  case let .blockListView(blockListAction):
    switch blockListAction {
    case let .selectUnblockUser(unblockUser):
      state.popupPresented = true
      state.unBlockUser = unblockUser
      print("")
    default:
      print("")
    }
    return .none
  case .getBlockUserList:
    return environment.appService.userService
      .getBlockUserList()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyBlockHistoryAction.getBlockUserListResponse)
  case let .getBlockUserListResponse(.success(response)):
    state.blockListView = .init(blockUsers: response ?? [])
    return Effect(value: .getBlockUserRequestSuccess)
  case .getBlockUserListResponse(.failure):
    return .none
  case .getBlockUserRequestSuccess:
    return .none
  case let .unblockUser(userId):
    return environment.appService.userService
      .unBlockUser(userId: userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyBlockHistoryAction.unblockUserResponse)
  case let .unblockUserResponse(.success(response)):
    return Effect(value: .unblockUserRequestSuccess)
  case .unblockUserResponse(.failure):
    return .none
  case .unblockUserRequestSuccess:
    state.popupPresented = false
    return Effect(value: .getBlockUserList)
  }
}
