//
//  PhoneVerificationCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import TTNetworkModule
import ComposableArchitecture

struct PhoneVerificationState: Equatable {
  var phoneNumber: String = ""
  var isAvailablePhoneNumber: Bool = false
  var expireMinute: Int = 0
}

enum PhoneVerificationAction: Equatable {
  case phoneNumberInput(text: String)
  case verificationButtonTap
  case checkPhoneNumberValidation
  case issuePhoneCodeResponse(Result<IssueCodeEntity.Response?, HTTPError>)
  case phoneNumberRequestSuccess
}

struct PhoneVerificationEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let phoneVerficationReducer = Reducer<
  PhoneVerificationState,
  PhoneVerificationAction,
  PhoneVerificationEnvironment
> { state, action, environment in
  switch action {
  case let .phoneNumberInput(text):
    state.phoneNumber = text
    return Effect(value: .checkPhoneNumberValidation)
  case .verificationButtonTap:
    let request = IssueCodeEntity.Request(phoneNumber: state.phoneNumber)
    return environment.appService.authService
      .issuePhoneCode(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(PhoneVerificationAction.issuePhoneCodeResponse)
  case let .issuePhoneCodeResponse(.success(response)):
    state.expireMinute = response?.expire ?? 0
    return Effect(value: .phoneNumberRequestSuccess)
  case .issuePhoneCodeResponse(.failure):
    return .none
  case .checkPhoneNumberValidation:
    let isAvailable = state.phoneNumber.checkPhoneNumber()
    state.isAvailablePhoneNumber = isAvailable
    return .none
  case .phoneNumberRequestSuccess:
    return .none
  }
}
