//
//  SignInCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct SignInState: Equatable {
  enum Route {
    case verificationNumberCheck
  }
  var route: Route?
  var phoneNumber: String = ""
  var verificationCode: String = ""
  var expireMinute: Int = 0
  var verificationNumberCheckState: VerificationNumberCheckState = .init()
  var phoneVerficationState: PhoneVerificationState = .init()
}

enum SignInAction: Equatable {
  case setRoute(SignInState.Route?)
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerficationAction(PhoneVerificationAction)
}

struct SignInEnvironment {
  var appService: AppService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signInReducer = Reducer<
  SignInState,
  SignInAction,
  SignInEnvironment
>.combine([
  verificationNumberCheckReducer
    .pullback(
      state: \.verificationNumberCheckState,
      action: /SignInAction.verificationNumberCheckAction,
      environment: {
        VerificationNumberCheckEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  phoneVerficationReducer
    .pullback(
      state: \.phoneVerficationState,
      action: /SignInAction.phoneVerficationAction,
      environment: {
        PhoneVerificationEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  signInCore
])

let signInCore = Reducer<
  SignInState,
  SignInAction,
  SignInEnvironment
> { state, action, _ in
  switch action {
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerficationAction(.phoneNumberRequestSuccess):
    state.verificationNumberCheckState.phoneNumber = state.phoneVerficationState.phoneNumber
    state.verificationNumberCheckState.expireMinute = state.phoneVerficationState.expireMinute
    return Effect(value: .setRoute(.verificationNumberCheck))
  case .phoneVerficationAction:
    return.none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.verificationNumberCheckState = .init()
    }
    state.route = selectedRoute
    return .none
  }
}
