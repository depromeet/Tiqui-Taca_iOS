//
//  SplashCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/08.
//

import ComposableArchitecture

struct SplashState: Equatable {
  enum Route: Identifiable {
    var id: Self { self }
    
    case mainTab
    case onboarding
  }
  var route: Route?
  var onboardingState: OnboardingState?
  var mainTabState: MainTabState?
}

enum SplashAction: Equatable {
  case setRoute(SplashState.Route?)
  case onAppear
  case onboardingAction(OnboardingAction)
  case mainTabAction(MainTabAction)
}

struct SplashEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let splashReducer = Reducer<
  SplashState,
  SplashAction,
  SplashEnvironment
>.combine([
  onBoardingReducer
    .optional()
    .pullback(
      state: \.onboardingState,
      action: /SplashAction.onboardingAction,
      environment: {
        OnboardingEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  mainTabReducer
    .optional()
    .pullback(
      state: \.mainTabState,
      action: /SplashAction.mainTabAction,
      environment: {
        MainTabEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  splashCore
])

let splashCore = Reducer<
  SplashState,
  SplashAction,
  SplashEnvironment
> { state, action, environment in
  switch action {
  case let .setRoute(selectedRoute):
    state.route = selectedRoute
    return .none
  case .onAppear:
    if environment.appService.authService.isLoggedIn {
      state.mainTabState = .init()
      return Effect(value: .setRoute(.mainTab))
    } else {
      state.onboardingState = .init()
      return Effect(value: .setRoute(.onboarding))
    }
  case .onboardingAction:
    return .none
  case .mainTabAction:
    return .none
  }
}
