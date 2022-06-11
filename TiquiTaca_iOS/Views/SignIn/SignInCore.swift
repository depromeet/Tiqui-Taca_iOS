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
  var verificationNumberCheckState: VerificationNumberCheckState?
  var phoneVerificationState: PhoneVerificationState = .init()
}

enum SignInAction: Equatable {
  case setRoute(SignInState.Route?)
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerificationAction(PhoneVerificationAction)
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
  phoneVerficationReducer
    .pullback(
      state: \.phoneVerificationState,
      action: /SignInAction.phoneVerificationAction,
      environment: {
        PhoneVerificationEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  signInCore
    .presents(
      verificationNumberCheckReducer,
      cancelEffectsOnDismiss: true,
      state: \.verificationNumberCheckState,
      action: /SignInAction.verificationNumberCheckAction,
      environment: {
        VerificationNumberCheckEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    )
])

let signInCore = Reducer<
  SignInState,
  SignInAction,
  SignInEnvironment
> { state, action, _ in
  switch action {
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerificationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setRoute(.verificationNumberCheck))
  case .phoneVerificationAction:
    return.none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.verificationNumberCheckState = nil
    } else if selectedRoute == .verificationNumberCheck {
      state.verificationNumberCheckState = .init(
        phoneNumber: state.phoneVerificationState.phoneNumber,
        expireSeconds: state.phoneVerificationState.expireMinute * 60
      )
    }
    state.route = selectedRoute
    return .none
  }
}
