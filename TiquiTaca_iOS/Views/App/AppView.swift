//
//  AppView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct AppView: View {
  typealias State = AppState
  typealias Action = AppAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route
    let isLoading: Bool
    
    init(state: State) {
      route = state.route
      isLoading = state.isLoading
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    Group {
      ZStack {
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
        TTIndicator(
          style: .medium,
          isAnimating: viewStore.binding(
            get: \.isLoading,
            send: Action.setLoading
          )
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
          mainQueue: .main,
          locationManager: .live,
          deeplinkManager: .shared
        )
      )
    )
  }
}
