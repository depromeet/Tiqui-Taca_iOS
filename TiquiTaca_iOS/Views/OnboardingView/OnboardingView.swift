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
            OnboardingTitleView()
            OnboardingPageView(
              currentPage: viewStore.binding(
                get: \.currentPage,
                send: OnboardingAction.onboardingPageSwipe
              )
            )
          }
          .vCenter()
          
          VStack(spacing: 24) {
            NavigationLink(
              isActive: viewStore.binding(
                get: \.isSignInViewPresent,
                send: OnboardingAction.setIsSignInViewPresent
              ), destination: {
                SignInView(
                  store: store.scope(
                    state: \.signInState,
                    action: OnboardingAction.signInAction
                  )
                )
              }, label: {
                Text("이미 계정이 있다면? ") + Text("로그인").fontWeight(.heavy)
              }
            )
            
            NavigationLink(
              isActive: viewStore.binding(
                get: \.isSignUpViewPresent,
                send: OnboardingAction.setIsSignUpViewPresent
              ), destination: {
                SignUpView(
                  store: store.scope(
                    state: \.signUpState,
                    action: OnboardingAction.signUpAction
                  )
                )
              }, label: {
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
        .navigationBarHidden(true)
        .padding(.bottom, 24)
      }
    }
  }
}

// MARK: TitleView
private struct OnboardingTitleView: View {
  var body: some View {
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
  }
}

// MARK: PageView
private struct OnboardingPageView: View {
  @Binding var currentPage: Int
  
  var body: some View {
    TabView(selection: $currentPage) {
      Image(systemName: "d.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(0)
      Image(systemName: "p.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(1)
      Image(systemName: "m.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
    .background(.white)
    .cornerRadius(16)
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(
      store: .init(
        initialState: OnboardingState(),
        reducer: onBoardingReducer,
        environment: OnboardingEnvironment(
          authService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
