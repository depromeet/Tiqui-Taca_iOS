//
//  OnboardingView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct OnboardingView: View {
  typealias State = OnboardingState
  typealias Action = OnboardingAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route?
    let currentPage: Int
    
    init(state: State) {
      route = state.route
      currentPage = state.currentPage
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .center, spacing: 79) {
        VStack {
          PageControl(
            numberOfPages: 3,
            currentPage: viewStore.binding(
              get: \.currentPage,
              send: Action.pageControlTapped
            )
          )
          PageView(
            currentPage: viewStore.binding(
              get: \.currentPage,
              send: Action.onboardingPageSwipe
            )
          )
        }
        .vCenter()
        
        VStack(spacing: 24) {
          NavigationLink(
            tag: State.Route.signIn,
            selection: viewStore.binding(
              get: \.route,
              send: Action.setRoute
            ),
            destination: {
              SignInView(store: signInStore)
            },
            label: {
              HStack {
                Text("이미 계정이 있다면? ")
                  .foregroundColor(.white500)
                Text("로그인")
                  .foregroundColor(.green500)
              }
            }
          )
          NavigationLink(
            tag: State.Route.signUp,
            selection: viewStore.binding(
              get: \.route,
              send: Action.setRoute
            ),
            destination: {
              SignUpView(store: signUpStore)
            },
            label: {
              Button {
                viewStore.send(.setRoute(.signUp))
              } label: {
                Text("시작하기")
              }
              .buttonStyle(TTButtonLargeGreenStyle())
            }
          )
        }
        .padding(.horizontal, .spacingXL)
        .padding(.bottom, .spacingS)
      }
      .background(Color.black800)
      .navigationBarTitleDisplayMode(.inline)
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

// MARK: - Store init
extension OnboardingView {
  private var signInStore: Store<SignInState, SignInAction> {
    return store.scope(
      state: \.signInState,
      action: Action.signInAction
    )
  }
  
  private var signUpStore: Store<SignUpState, SignUpAction> {
    return store.scope(
      state: \.signUpState,
      action: Action.signUpAction
    )
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(
      store: .init(
        initialState: .init(),
        reducer: onBoardingReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
