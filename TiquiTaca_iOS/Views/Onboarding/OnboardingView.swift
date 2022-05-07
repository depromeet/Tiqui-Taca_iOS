//
//  OnboardingView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
  let store: Store<OnboardingState, OnboardingAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        VStack(alignment: .center, spacing: 8) {
          VStack {
            PageControl(
              numberOfPages: 3,
              currentPage: viewStore.binding(
                get: \.currentPage,
                send: OnboardingAction.pageControlTapped
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
                send: OnboardingAction.onboardingPageSwipe
              )
            )
          }
          .vCenter()
          
          VStack(spacing: 24) {
            NavigationLink(
              tag: OnboardingState.Route.signIn,
              selection: viewStore.binding(
                get: \.route,
                send: OnboardingAction.setRoute
              ),
              destination: {
                SignInView(store: signInStore)
              },
              label: {
                Text("이미 계정이 있다면? ") + Text("로그인").fontWeight(.heavy)
              }
            )
            
            NavigationLink(
              tag: OnboardingState.Route.signUp,
              selection: viewStore.binding(
                get: \.route,
                send: OnboardingAction.setRoute
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
}

// MARK: - Store init
extension OnboardingView {
  private var signInStore: Store<SignInState, SignInAction> {
    return store.scope(
      state: \.signInState,
      action: OnboardingAction.signInAction
    )
  }
  
  private var signUpStore: Store<SignUpState, SignUpAction> {
    return store.scope(
      state: \.signUpState,
      action: OnboardingAction.signUpAction
    )
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(
      store: .init(
        initialState: OnboardingState(),
        reducer: onBoardingReducer,
        environment: OnboardingEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
