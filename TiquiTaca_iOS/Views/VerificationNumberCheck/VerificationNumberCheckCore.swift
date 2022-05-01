//
//  VerificationNumberCheckCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct VerificationNumberCheckState: Equatable {
  var phoneNumber: String = ""
  var certificationCode: String = ""
  var otpFieldState: OTPFieldState = .init()
}

enum VerificationNumberCheckAction: Equatable {
  case certificationButtonTapped
  case otpFieldAction(OTPFieldAction)
}

struct VerificationNumberCheckEnvironment {
  var authService: AuthService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let phoneCertificateReducer = Reducer<
  VerificationNumberCheckState,
  VerificationNumberCheckAction,
  VerificationNumberCheckEnvironment
>.combine([
  // next view pullback: 약관동의화면
  otpFieldReducer
    .pullback(
      state: \.otpFieldState,
      action: /VerificationNumberCheckAction.otpFieldAction,
      environment: { _ in
        OTPFieldEnvironment()
      }
    ),
  phoneCertificateCore
])

let phoneCertificateCore = Reducer<
  VerificationNumberCheckState,
  VerificationNumberCheckAction,
  VerificationNumberCheckEnvironment
> { state, action, environment in
  switch action {
  case let .otpFieldAction(.valueChanged):
    //    state.otpFieldState.result
    return .none
    //  case let .certificationCodeChanged(certificationCode, index):
    //    state.certificationCode = certificationCode
    //    state.certificationCodeFields[index] = certificationCode
    //    return .none
    //  case .certificationButtonTapped:
    //    return environment.authService
    //      .checkVerification(state.phoneNumber, state.certificationCode)
    //      .receive(on: environment.mainQueue)
    //      .catchToEffect(PhoneCertificateAction.certificationResponse)
    //  case let .certificationResponse(.success(certificationResponse)):
    //    state.successFlag = true
    //    print(certificationResponse.data.tempToken.token)
    //    return .none
    //  case .certificationResponse(.failure):
    //    return Effect(value: PhoneCertificateAction.certificationCodeError)
    //  case .certificationCodeError:
    //    state.successFlag = false
    //    //    state.certificationCodeFields.removeAll()
    //    return .none
    //  case .certificationCodeRemoved:
    //    state.successFlag = nil
    //    return .none
  default:
    return .none
  }
}
