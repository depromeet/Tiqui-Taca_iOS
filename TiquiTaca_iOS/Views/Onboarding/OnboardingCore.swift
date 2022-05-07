//
//  OnboardingCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import ComposableArchitecture

struct OnboardingState: Equatable {
  enum Route {
    case signIn
    case signUp
  }
  var route: Route?
  var currentPage: Int = 0
  var signInState: SignInState = .init()
  var signUpState: SignUpState = .init()
}

enum OnboardingAction: Equatable {
  case setRoute(OnboardingState.Route?)
  case pageControlTapped(Int)
  case onboardingPageSwipe(Int)
  case signInAction(SignInAction)
  case signUpAction(SignUpAction)
}

struct OnboardingEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let onBoardingReducer = Reducer<
  OnboardingState,
  OnboardingAction,
  OnboardingEnvironment
>.combine([
  signInReducer
    .pullback(
      state: \.signInState,
      action: /OnboardingAction.signInAction,
      environment: {
        SignInEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  signUpReducer
    .pullback(
      state: \.signUpState,
      action: /OnboardingAction.signUpAction,
      environment: {
        SignUpEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  onBoardingCore
])
#if DEBUG
.debug()
#endif

let onBoardingCore = Reducer<
  OnboardingState,
  OnboardingAction,
  OnboardingEnvironment
> { state, action, _ in
  switch action {
  case .onboardingPageSwipe(let page):
    state.currentPage = page
    return .none
  case .pageControlTapped(let page):
    return .none
  case .signInAction:
    return .none
  case .signUpAction:
    return .none
  case let .setRoute(selectedRoute):
    if selectedRoute == nil {
      state.signInState = .init()
      state.signUpState = .init()
    }
    state.route = selectedRoute
    return .none
  }
}
