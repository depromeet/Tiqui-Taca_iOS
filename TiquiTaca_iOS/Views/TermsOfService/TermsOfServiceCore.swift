//
//  TermsOfServiceCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/20.
//

import ComposableArchitecture

struct TermsOfServiceState: Equatable {
  enum Route {
    case createProfile
  }
  var route: Route?
  var tosFieldListState: TOSFieldListViewState = .init()
  var createProfileState: CreateProfileState = .init()
}

enum TermsOfServiceAction: Equatable {
  case setRoute(TermsOfServiceState.Route?)
  case tosFieldListAction(TOSFieldListViewAction)
  case createProfileAction(CreateProfileAction)
}

struct TermsOfServiceEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let termsOfServiceReducer = Reducer<
  TermsOfServiceState,
  TermsOfServiceAction,
  TermsOfServiceEnvironment
>.combine([
  tosFieldListViewReducer
    .pullback(
      state: \.tosFieldListState,
      action: /TermsOfServiceAction.tosFieldListAction,
      environment: { _ in Void() }
    ),
  createProfileReducer
    .pullback(
      state: \.createProfileState,
      action: /TermsOfServiceAction.createProfileAction,
      environment: {
        CreateProfileEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  termsOfServiceReducerCore
])

let termsOfServiceReducerCore = Reducer<
  TermsOfServiceState,
  TermsOfServiceAction,
  TermsOfServiceEnvironment
> { state, action, _ in
  switch action {
  case .tosFieldListAction:
    return .none
  case .createProfileAction:
    return .none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.createProfileState = .init()
    }
    state.route = selectedRoute
    return .none
  }
}
