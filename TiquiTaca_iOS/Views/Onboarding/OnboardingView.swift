//
//  OnboardingView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

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
      VStack(alignment: .center, spacing: 8) {
        VStack {
          PageControl(
            numberOfPages: 3,
            currentPage: viewStore.binding(
              get: \.currentPage,
              send: Action.pageControlTapped
            )
          )
          
          VStack(spacing: 8) {
            Text("Welcome Tiki Taka")
              .font(.system(size: 24))
              .fontWeight(.semibold)
            Text("Hello, Welcome!\nEnjoy Enjoy Enjoy")
              .font(.system(size: 14))
              .multilineTextAlignment(.center)
              .frame(alignment: .center)
              .padding(.vertical, 8)
          }
          
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
              Text("이미 계정이 있다면? ") + Text("로그인").fontWeight(.heavy)
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
              Text("시작하기")
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(16)
            }
          )
        }
        .padding(.horizontal, 16)
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationViewStyle(StackNavigationViewStyle())
      .padding(.bottom, 24)
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
