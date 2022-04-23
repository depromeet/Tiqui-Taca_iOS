//
//  SignInViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/23.
//

import ComposableArchitecture
import TTNetworkModule

struct SignInState: Equatable {
  var phoneNumber: String = ""
  var verificationCode: String = ""
}

enum SignInAction: Equatable {
  case phoneCodeResponse(Result<TTDataResponse<PhoneCodeResponse>, TTApi.HTTPError>)
  case phoneCodeButtonTapped(String)
  case phoneNumberChanged(String)
  static func == (lhs: SignInAction, rhs: SignInAction) -> Bool {
    return true
  }
}

struct SignInEnvironment {
  var authService: AuthService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let signInReducer = Reducer<SignInState, SignInAction, SignInEnvironment> { state, action, environment in
  switch action {
  case let .phoneNumberChanged(phoneNumber):
    state.phoneNumber = phoneNumber
    return .none
  case let .phoneCodeButtonTapped(phoneNumber):
    return environment.authService
      .getPhoneCode(phoneNumber)
      .receive(on: environment.mainQueue)
      .catchToEffect(SignInAction.phoneCodeResponse)
  case let .phoneCodeResponse(.success(phoneResponse)):
    state.verificationCode = phoneResponse.data.verficiationCode
    return .none
  default:
    return .none
  }
}
