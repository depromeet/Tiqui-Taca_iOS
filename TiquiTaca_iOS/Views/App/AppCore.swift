//
//  AppCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/09.
//

import ComposableArchitecture
import ComposableCoreLocation
import TTNetworkModule

struct AppState: Equatable {
  enum Route {
    case splash
    case onboarding
    case mainTab
  }
  var route: Route = .splash
  var onboardingState: OnboardingState?
  var mainTabState: MainTabState?
  var isLoading: Bool = false
}

enum AppAction: Equatable {
  case setRoute(AppState.Route)
  case onAppear
  case signIn
  case signOut
  case onboardingAction(OnboardingAction)
  case mainTabAction(MainTabAction)
  case setLoading(Bool)
  case getMyProfileResponse(Result<UserEntity.Response?, HTTPError>)
}

struct AppEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var locationManager: LocationManager
}

let appReducer = Reducer<
  AppState,
  AppAction,
  AppEnvironment
>.combine([
  onBoardingReducer
    .optional()
    .pullback(
      state: \.onboardingState,
      action: /AppAction.onboardingAction,
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
      action: /AppAction.mainTabAction,
      environment: {
        MainTabEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue,
          locationManager: $0.locationManager
        )
      }
    ),
  appCore
])

let appCore = Reducer<
  AppState,
  AppAction,
  AppEnvironment
> { state, action, environment in
  switch action {
  case let .setRoute(selectedRoute):
    state.route = selectedRoute
    return .none
    
  case let .setLoading(isLoading):
    state.isLoading = isLoading
    return .none
    
  case .onAppear:
    if environment.appService.authService.isLoggedIn {
      return environment.appService.userService
        .fetchMyProfile()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.getMyProfileResponse)
    } else {
      state.onboardingState = .init()
      return Effect(value: .setRoute(.onboarding))
    }
    
  case .getMyProfileResponse:
    state.mainTabState = .init()
    return Effect(value: .setRoute(.mainTab))
    
  case .signIn: // 로그인 (하위 reducer의 로그인 관련 이벤트)
    environment.appService.authService.deleteTempToken()
    state.mainTabState = .init()
    state.onboardingState = nil
    return Effect(value: .setRoute(.mainTab))
    
  case .signOut: // 로그아웃 (하위 reducer의 로그아웃 관련 이벤트)
    state.mainTabState = nil
    state.onboardingState = .init()
    
    return .concatenate([
      Effect(value: .setLoading(true)),
      environment.appService.authService
        .signOut()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .fireAndForget(),
      Effect(value: .setLoading(false)),
      Effect(value: .setRoute(.onboarding))
    ])
    
  case .onboardingAction( // 로그인
    .signInAction(
      .verificationNumberCheckAction(.loginSuccess)
    )
  ):
    return Effect(value: .signIn)
    
  case .onboardingAction( // 회원가입
    .signUpAction(
      .verificationNumberCheckAction(.loginSuccess)
    )
  ):
    return Effect(value: .signIn)
    
  case .onboardingAction( // 로그인 -> 유저생성
    .signInAction(
      .verificationNumberCheckAction(
        .termsOfServiceAction(
          .createProfileAction(.createUserSuccess)
        )
      )
    )
  ):
    return Effect(value: .signIn)
    
  case .onboardingAction( // 회원가입 -> 유저생성
    .signUpAction(
      .verificationNumberCheckAction(
        .termsOfServiceAction(
          .createProfileAction(.createUserSuccess)
        )
      )
    )
  ):
    return Effect(value: .signIn)
    
  case .mainTabAction(.myPageAction(.logout)):
    return Effect(value: .signOut)
    
  case .onboardingAction:
    return .none
    
  case .mainTabAction:
    return .none
  }
}
