//
//  VerificationNumberCheckCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule
import Foundation

struct VerificationNumberCheckState: Equatable {
  enum Route {
    case termsOfService
  }
  var route: Route?
  var phoneNumber: String = ""
  var expireSeconds: Int = 0
  var isAvailable: Bool = true
  var otpFieldState: OTPFieldState = .init()
  var termsOfServiceState: TermsOfServiceState?
}

enum VerificationNumberCheckAction: Equatable {
  case setRoute(VerificationNumberCheckState.Route?)
  
  case timerStart
  case timerTicked
  case timerStop
  
  case loginSuccess
  case requestAgain
  case verificationResponse(Result<VerificationEntity.Response?, HTTPError>)
  case issuePhoneCodeResponse(Result<IssueCodeEntity.Response?, HTTPError>)
  
  case otpFieldAction(OTPFieldAction)
  case termsOfServiceAction(TermsOfServiceAction)
  case mainTabAction(MainTabAction)
}

struct VerificationNumberCheckEnvironment {
  var appService: AppService
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let verificationNumberCheckReducer = Reducer<
  VerificationNumberCheckState,
  VerificationNumberCheckAction,
  VerificationNumberCheckEnvironment
>.combine([
  termsOfServiceReducer
    .optional()
    .pullback(
      state: \.termsOfServiceState,
      action: /VerificationNumberCheckAction.termsOfServiceAction,
      environment: {
        TermsOfServiceEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  otpFieldReducer
    .pullback(
      state: \.otpFieldState,
      action: /VerificationNumberCheckAction.otpFieldAction,
      environment: { _ in Void() }
    ),
  verificationNumberCheckCore
])

let verificationNumberCheckCore = Reducer<
  VerificationNumberCheckState,
  VerificationNumberCheckAction,
  VerificationNumberCheckEnvironment
> { state, action, environment in
  struct TimerId: Hashable {}
  
  switch action {
  case .loginSuccess:
    return.none
    
  case .timerStart:
    return Effect.timer(id: TimerId(), every: 1, on: environment.mainQueue)
      .map { _ in .timerTicked }
    
  case .timerTicked:
    state.expireSeconds -= 1
    if state.expireSeconds <= 0 {
      return Effect(value: .timerStop)
    } else {
      return .none
    }
    
  case .timerStop:
    state.isAvailable = false
    return .cancel(id: TimerId())
    
  case .requestAgain:
    let requestModel = IssueCodeEntity.Request(phoneNumber: state.phoneNumber)
    return environment.appService.authService
      .issuePhoneCode(request: requestModel)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(VerificationNumberCheckAction.issuePhoneCodeResponse)
    
  case let .verificationResponse(.success(response)):
    guard let response = response else { return .none }
    if let tempToken = response.tempToken {
      try? TokenManager.shared.saveTempToken(tempToken)
      return Effect(value: .setRoute(.termsOfService))
    }
    
    if let accessToken = response.accessToken,
       let refreshToken = response.refreshToken,
       let user = response.user {
      try? TokenManager.shared.saveAccessToken(accessToken)
      try? TokenManager.shared.saveRefreshToken(refreshToken)
      // MARK: - user 정보 저장 필요
      // userService.saveUser...
      return Effect(value: .loginSuccess)
    }
    return .none
    
  case let .issuePhoneCodeResponse(.success(response)):
    guard let response = response else { return .none }
    state.expireSeconds = response.expire * 60
    return .merge([
      .cancel(id: TimerId()),
      Effect(value: .timerStart)
    ])
    
  case .verificationResponse(.failure):
    return .none
    
  case .issuePhoneCodeResponse(.failure):
    return .none
    
  case .otpFieldAction(.lastFieldTrigger):
    let requestModel = VerificationEntity.Request(
      phoneNumber: state.phoneNumber,
      verificationCode: state.otpFieldState.result
    )
    return environment.appService.authService
      .verification(request: requestModel)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(VerificationNumberCheckAction.verificationResponse)
    
  case .termsOfServiceAction:
    return .none
    
  case .mainTabAction:
    return .none
    
  case .otpFieldAction:
    return .none
    
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.termsOfServiceState = nil
    } else if selectedRoute == .termsOfService {
      state.termsOfServiceState = .init()
    }
    state.route = selectedRoute
    return .none
  }
}
