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
  var isPhoneCertificateViewPresent = false
  var expireMinute: Int = 0
  
  var phoneCertificateState: VerificationNumberCheckState = .init()
  var phoneVerficationState: PhoneVerificationState = .init()
}

enum SignInAction: Equatable {
  case setIsPhoneCertificateViewPresent(Bool)
  
  case phoneCertificateAction(VerificationNumberCheckAction)
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
  phoneCertificateReducer
    .pullback(
      state: \.phoneCertificateState,
      action: /SignInAction.phoneCertificateAction,
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
  case let .setIsPhoneCertificateViewPresent(isPresent):
    state.isPhoneCertificateViewPresent = isPresent
    return .none
  case .phoneCertificateAction:
    return .none
  case .phoneVerficationAction(.phoneNumberRequestSuccess):
    return Effect(value: .setIsPhoneCertificateViewPresent(true))
  case .phoneVerficationAction:
    return.none
  }
}
