//
//  OnboardingCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import Foundation
import ComposableArchitecture

struct OnboardingState: Equatable {
	var currentPage: Int = 0
  var isSignInViewPresent: Bool = false
  var isSignUpViewPresent: Bool = false
  
  var signInState: SignInState = .init()
  var signUpState: SignUpState = .init()
}

enum OnboardingAction: Equatable {
	case pageControlTapped(Int)
	case onboardingPageSwipe(Int)
  case setIsSignInViewPresent(Bool)
  case setIsSignUpViewPresent(Bool)
  
  case signInAction(SignInAction)
  case signUpAction(SignUpAction)
}

struct OnboardingEnvironment {
  let authService: AuthService
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
          authService: $0.authService,
          mainQueue: .main
        )
      }
    ),
  signUpReducer
    .pullback(
      state: \.signUpState,
      action: /OnboardingAction.signUpAction,
      environment: {
        SignUpEnvironment(
          authService: $0.authService,
          mainQueue: .main
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
  case let .setIsSignInViewPresent(isPresent):
    if !isPresent {
      state.signInState = .init()
    }
    state.isSignInViewPresent = isPresent
    return .none
  case let .setIsSignUpViewPresent(isPresent):
    if !isPresent {
      state.signUpState = .init()
    }
    state.isSignUpViewPresent = isPresent
    return .none
  }
}
