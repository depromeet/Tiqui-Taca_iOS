//
//  SignUpCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct SignUpState: Equatable {
  var phoneNumber: String = ""
  var verificationCode: String = ""
  var isNextViewPresent = false
  var expireMinute: Int = 0
  
  var verificationNumberCheckState: VerificationNumberCheckState = .init()
  var phoneVerficationState: PhoneVerificationState = .init()
}

enum SignUpAction: Equatable {
  case setIsNextViewPresent(Bool)
  
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerficationAction(PhoneVerificationAction)
}

struct SignUpEnvironment {
  var authService: AuthService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signUpReducer = Reducer<
  SignUpState,
  SignUpAction,
  SignUpEnvironment
>.combine([
  verificationNumberCheckReducer
    .pullback(
      state: \.verificationNumberCheckState,
      action: /SignUpAction.verificationNumberCheckAction,
      environment: {
        VerificationNumberCheckEnvironment(
          authService: $0.authService,
          mainQueue: .main
        )
      }
    ),
  phoneVerficationReducer
    .pullback(
      state: \.phoneVerficationState,
      action: /SignUpAction.phoneVerficationAction,
      environment: {
        PhoneVerificationEnvironment(
          authService: $0.authService,
          mainQueue: .main
        )
      }
    ),
  signUpCore
])

let signUpCore = Reducer<
  SignUpState,
  SignUpAction,
  SignUpEnvironment
> { state, action, environment in
  switch action {
  case let .setIsNextViewPresent(isNextViewPresent):
    state.isNextViewPresent = isNextViewPresent
    return .none
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerficationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setIsNextViewPresent(true))
  case .phoneVerficationAction:
    return.none
  }
}
