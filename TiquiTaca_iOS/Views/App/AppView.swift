//
//  AppView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  typealias State = AppState
  typealias Action = AppAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route
    
    init(state: State) {
      route = state.route
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    Group {
      switch viewStore.route {
      case .splash:
        SplashView()
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
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
}

// MARK: - Store init
extension AppView {
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

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      store: .init(
        initialState: .init(),
        reducer: appReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
