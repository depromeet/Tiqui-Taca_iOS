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
  var phoneVerficationState: PhoneVerificationState = .init()
}

enum SignUpAction: Equatable {
  case setRoute(SignUpState.Route?)
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerficationAction(PhoneVerificationAction)
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
  verificationNumberCheckReducer
    .optional()
    .pullback(
      state: \.verificationNumberCheckState,
      action: /SignUpAction.verificationNumberCheckAction,
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
      action: /SignUpAction.phoneVerficationAction,
      environment: {
        PhoneVerificationEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  signUpCore
])

let signUpCore = Reducer<
  SignUpState,
  SignUpAction,
  SignUpEnvironment
> { state, action, _ in
  switch action {
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerficationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setRoute(.verificationNumberCheck))
  case .phoneVerficationAction:
    return .none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.verificationNumberCheckState = nil
    } else if selectedRoute == .verificationNumberCheck {
      state.verificationNumberCheckState = .init(
        phoneNumber: state.phoneVerficationState.phoneNumber,
        expireSeconds: state.phoneVerficationState.expireMinute * 60,
        verificationCode: state.phoneVerficationState.verificationCode
      )
    }
    state.route = selectedRoute
    return .none
  }
}
