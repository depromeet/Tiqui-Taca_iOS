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
    case block
    case report
    case letter
    case lightning
    case none
  }
  
  var userId: String
  var userInfo: UserEntity.Response?
  
  var showPopup: Bool = false
  var showProfile: Bool = false
  var isFirstLoad: Bool = true
  var currentAction: Action = .none
}

enum OtherProfileAction: Equatable {
  case setShowProfile(Bool)
  case setAction(OtherProfileState.Action)
  // MARK: Action API
  case fetchUserInfo
  case userBlock
  case userReport
  case userGiveLightning
  
  // MARK: Action Response
  case responseUserInfo(Result<UserEntity.Response?, HTTPError>)
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
  case let .responseUserInfo(.success(userInfo)):
    state.userInfo = userInfo
    state.showProfile = true
    return .none
  case .responseUserInfo(.failure):
    return .none
  default:
    return .none
  }
}
