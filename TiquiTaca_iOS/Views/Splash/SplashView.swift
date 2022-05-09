//
//  SplashView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
  typealias State = SplashState
  typealias Action = SplashAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route?
    
    init(state: State) {
      route = state.route
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 24) {
      Image("SplashLogo")
      Image("SplashLogoText")
    }
    .hCenter()
    .vCenter()
    .background(Color.black800)
    .onAppear {
      viewStore.send(.onAppear)
    }
    .fullScreenCover(
      item: viewStore.binding(
        get: \.route,
        send: SplashAction.setRoute
      )
    ) { item in
      switch item {
      case .onboarding:
        IfLetStore(
          onboardingStore,
          then: OnboardingView.init
        )
      case .mainTab:
        IfLetStore(
          mainTabStore,
          then: MainTabView.init
        )
      }
    }
  }
}

// MARK: - Store init
extension SplashView {
  private var onboardingStore: Store<OnboardingState?, OnboardingAction> {
    return store.scope(
      state: \.onboardingState,
      action: Action.onboardingAction
    )
  }
  
  private var mainTabStore: Store<MainTabState?, MainTabAction> {
    return store.scope(
      state: \.mainTabState,
      action: Action.mainTabAction
    )
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView(
      store: .init(
        initialState: .init(),
        reducer: splashReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
