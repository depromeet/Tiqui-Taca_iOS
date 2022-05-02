//
//  SignInCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct SignInState: Equatable {
  var phoneNumber: String = ""
  var verificationCode: String = ""
  var isVerificationNumberCheckViewPresent = false
  var expireMinute: Int = 0
  
  var verificationNumberCheckState: VerificationNumberCheckState = .init()
  var phoneVerficationState: PhoneVerificationState = .init()
}

enum SignInAction: Equatable {
  case setIsVerificationNumberCheckViewPresent(Bool)
  
  case verificationNumberCheckAction(VerificationNumberCheckAction)
  case phoneVerficationAction(PhoneVerificationAction)
}

struct SignInEnvironment {
  var authService: AuthService
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
          authService: $0.authService,
          mainQueue: .main
        )
      }
    ),
  phoneVerficationReducer
    .pullback(
      state: \.phoneVerficationState,
      action: /SignInAction.phoneVerficationAction,
      environment: {
        PhoneVerificationEnvironment(
          authService: $0.authService,
          mainQueue: .main
        )
      }
    ),
  signInCore
])

let signInCore = Reducer<
  SignInState,
  SignInAction,
  SignInEnvironment
> { state, action, environment in
  switch action {
  case let .setIsVerificationNumberCheckViewPresent(isPresent):
    state.isVerificationNumberCheckViewPresent = isPresent
    return .none
  case .verificationNumberCheckAction:
    return .none
  case .phoneVerficationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setIsVerificationNumberCheckViewPresent(true))
  case .phoneVerficationAction:
    return.none
  }
}
