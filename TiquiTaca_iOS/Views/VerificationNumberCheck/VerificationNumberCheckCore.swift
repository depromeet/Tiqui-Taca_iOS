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
  case compareVerficationNumberResponse(Result<VerificationEntity.Response?, HTTPError>)
  case otpFieldAction(OTPFieldAction)
}

struct VerificationNumberCheckEnvironment {
  var authService: AuthServiceType
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let verificationNumberCheckReducer = Reducer<
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
  verificationNumberCheckCore
])

let verificationNumberCheckCore = Reducer<
  VerificationNumberCheckState,
  VerificationNumberCheckAction,
  VerificationNumberCheckEnvironment
> { state, action, environment in
  switch action {
  case let .compareVerficationNumberResponse(.success(response)):
    guard let response = response else { return .none }
    if let tempToken = response.tempToken {
      // 사용자 생성을 위한 임시 토큰 저장
      // 약관 동의 화면으로
    }
    return .none
  case .compareVerficationNumberResponse(.failure):
    return .none
  case .otpFieldAction(.lastFieldTrigger):
    let requestModel = VerificationEntity.Request(
      phoneNumber: state.phoneNumber,
      verificationCode: state.otpFieldState.otpText
    )
    return environment.authService
      .verification(request: requestModel)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(VerificationNumberCheckAction.compareVerficationNumberResponse)
  case .otpFieldAction:
    return .none
  }
}
