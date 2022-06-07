//
//  SignUpCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct SignUpState: Equatable {
  enum Route {
    case verificationNumberCheck
  }
  var route: Route?
  var verificationNumberCheckState: VerificationNumberCheckState?
  var phoneVerificationState: PhoneVerificationState = .init()
}

enum SignUpAction: Equatable {
  case setRoute(SignUpState.Route?)
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerificationAction(PhoneVerificationAction)
}

struct SignUpEnvironment {
  var appService: AppService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signUpReducer = Reducer<
  SignUpState,
  SignUpAction,
  SignUpEnvironment
>.combine([
  phoneVerficationReducer
    .pullback(
      state: \.phoneVerificationState,
      action: /SignUpAction.phoneVerificationAction,
      environment: {
        PhoneVerificationEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  signUpCore
    .presents(
      verificationNumberCheckReducer,
      cancelEffectsOnDismiss: true,
      state: \.verificationNumberCheckState,
      action: /SignUpAction.verificationNumberCheckAction,
      environment: {
        VerificationNumberCheckEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    )
])

let signUpCore = Reducer<
  SignUpState,
  SignUpAction,
  SignUpEnvironment
> { state, action, _ in
  switch action {
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerificationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setRoute(.verificationNumberCheck))
  case .phoneVerificationAction:
    return .none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.verificationNumberCheckState = nil
    } else if selectedRoute == .verificationNumberCheck {
      state.verificationNumberCheckState = .init(
        phoneNumber: state.phoneVerificationState.phoneNumber,
        expireSeconds: state.phoneVerificationState.expireMinute * 60,
        verificationCode: state.phoneVerificationState.verificationCode
      )
    }
    state.route = selectedRoute
    return .none
  }
}
