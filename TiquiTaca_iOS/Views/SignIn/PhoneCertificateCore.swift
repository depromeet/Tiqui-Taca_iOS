//
//  PhoneCertificateCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/23.
//

import ComposableArchitecture
import TTNetworkModule

struct PhoneCertificateState: Equatable {
  var phoneNumber: String
  var certificationCode: String
  var certificationCodeFields: [String] = Array(repeating: "", count: 6)
  var successFlag: Bool?
}

enum PhoneCertificateAction: Equatable {
  case certificationCodeChanged(value: String, index: Int)
  case certificationButtonTapped
  case certificationResponse(Result<TTDataResponse<VerificationResponse>, TTApi.HTTPError>)
  case certificationCodeError
  case certificationCodeRemoved
  static func == (lhs: PhoneCertificateAction, rhs: PhoneCertificateAction) -> Bool {
    return true
  }
}

struct PhoneCertificateEnvironment {
  var authService: AuthService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let phoneCertificateReducer = Reducer<
  PhoneCertificateState,
  PhoneCertificateAction,
  PhoneCertificateEnvironment
> { state, action, environment in
  switch action {
  case let .certificationCodeChanged(certificationCode, index):
    state.certificationCode = certificationCode
    state.certificationCodeFields[index] = certificationCode
    return .none
  case .certificationButtonTapped:
    return environment.authService
      .checkVerification(state.phoneNumber, state.certificationCode)
      .receive(on: environment.mainQueue)
      .catchToEffect(PhoneCertificateAction.certificationResponse)
  case let .certificationResponse(.success(certificationResponse)):
    state.successFlag = true
    print(certificationResponse.data.tempToken.token)
    return .none
  case .certificationResponse(.failure):
    return Effect(value: PhoneCertificateAction.certificationCodeError)
  case .certificationCodeError:
    state.successFlag = false
//    state.certificationCodeFields.removeAll()
    return .none
  case .certificationCodeRemoved:
    state.successFlag = nil
    return .none
  }
}
