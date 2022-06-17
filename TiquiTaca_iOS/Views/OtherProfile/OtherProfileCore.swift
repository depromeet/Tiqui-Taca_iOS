//
//  OtherProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/07.
//

import Combine
import ComposableArchitecture
import TTNetworkModule

struct OtherProfileState: Equatable {
  enum Action {
    case unblock
    case block
    case report
    case letter
    case lightning
    case none
  }
  
  var userId: String
  var userInfo: UserEntity.Response?
  
  var showProfile: Bool = false
  var showPopup: Bool = false
  var showAlreadySendLightning = false
  var isFirstLoad: Bool = true
  var currentAction: Action = .none
  var completeAction: Action = .none
}

enum OtherProfileAction: Equatable {
  static func == (lhs: OtherProfileAction, rhs: OtherProfileAction) -> Bool {
    false
  }
  
  case setShowProfile(Bool)
  case setAction(OtherProfileState.Action)
  // MARK: Action API
  case fetchUserInfo
  case userUnblock
  case userBlock
  case userReport
  case userSendLightning
  
  // MARK: Action Response
  case responseUserInfo(Result<UserEntity.Response?, HTTPError>)
  case responseUserBlock(Result<[BlockUserEntity.Response]?, HTTPError>)
  case responseUserUnblock(Result<[BlockUserEntity.Response]?, HTTPError>)
  case responseUserReport(Result<ReportEntity.Response?, HTTPError>)
  case responseSendLightning(Result<SendLightningResponse?, HTTPError>)
}

struct OtherProfileEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let otherProfileReducer = Reducer<
  OtherProfileState,
  OtherProfileAction,
  OtherProfileEnvironment
> { state, action, environment in
  switch action {
  case let .setShowProfile(isShow):
    state.showProfile = isShow
    return .none
  case let .setAction(action):
    state.currentAction = action
    state.showPopup = action != .none
    return .none
  case .fetchUserInfo:
    guard !state.userId.isEmpty && state.isFirstLoad else { return .none }
    state.isFirstLoad = false
    return environment.appService.userService
      .getOtherUserProfile(userId: state.userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(OtherProfileAction.responseUserInfo)
  case .userBlock:
    return environment.appService.userService
      .blockUser(userId: state.userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(OtherProfileAction.responseUserBlock)
  case .userUnblock:
    return environment.appService.userService
      .unBlockUser(userId: state.userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(OtherProfileAction.responseUserUnblock)
  case .userReport:
    return environment.appService.userService
      .reportUser(userId: state.userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(OtherProfileAction.responseUserReport)
  case .userSendLightning:
    return environment.appService.userService
      .sendLightning(userId: state.userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(OtherProfileAction.responseSendLightning)
  case let .responseUserInfo(.success(userInfo)):
    state.userInfo = userInfo
    state.showProfile = true
    return .none
  case let .responseUserBlock(.success(blockList)):
    state.completeAction = .block
    return .none
  case let .responseUserUnblock(.success(blockList)):
    state.completeAction = .unblock
    return .none
  case let .responseUserReport(.success(report)):
    if report?.reportSuccess == true {
      state.completeAction = .report
    }
    return .none
  case let .responseSendLightning(.success(lightning)):
    if lightning?.sendLightningSuccess == true {
      state.completeAction = .lightning
    } else {
      state.showPopup = false
      state.showAlreadySendLightning = true
    }
    return .none
  case .responseUserInfo(.failure):
    return .none
  case .responseUserBlock(.failure),
      .responseUserUnblock(.failure),
      .responseUserReport(.failure),
      .responseSendLightning(.failure):
    return .none
  }
}
