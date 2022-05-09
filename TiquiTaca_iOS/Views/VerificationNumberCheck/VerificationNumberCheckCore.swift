//
//  VerificationNumberCheckCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule

struct VerificationNumberCheckState: Equatable {
  enum Route {
    case termsOfService
    case main
  }
  var route: Route?
  var phoneNumber: String = ""
  var expireMinute: Int = 0
  var certificationCode: String = ""
  var isLoginSuccess: Bool = false
  var otpFieldState: OTPFieldState = .init()
  var termsOfServiceState: TermsOfServiceState = .init()
  var mainTabState: MainTabState = .init()
}

enum VerificationNumberCheckAction: Equatable {
  case setRoute(VerificationNumberCheckState.Route?)
  case compareVerficationNumberResponse(Result<VerificationEntity.Response?, HTTPError>)
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
  mainTabReducer
    .pullback(
      state: \.mainTabState,
      action: /VerificationNumberCheckAction.mainTabAction,
      environment: {
        MainTabEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  termsOfServiceReducer
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
  switch action {
  case let .compareVerficationNumberResponse(.success(response)):
    guard let response = response else { return .none }
    if let tempToken = response.tempToken {
      try? TokenManager.shared.saveTempToken(tempToken)
      return Effect(value: .setRoute(.termsOfService))
    }
    
    return .none
  case .compareVerficationNumberResponse(.failure):
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
      .map(VerificationNumberCheckAction.compareVerficationNumberResponse)
  case .termsOfServiceAction:
    return .none
  case .mainTabAction:
    return .none
  case .otpFieldAction:
    return .none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.termsOfServiceState = .init()
    }
    state.route = selectedRoute
    return .none
  }
}
