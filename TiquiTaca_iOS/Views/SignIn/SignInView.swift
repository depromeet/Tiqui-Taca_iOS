//
//  SignInView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import SwiftUI
import ComposableArchitecture

struct SignInView: View {
  typealias State = SignInState
  typealias Action = SignInAction
  
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
    VStack {
      Spacer()
      VStack(alignment: .leading, spacing: 10) {
        Text("로그인을 위해\n휴대폰 번호를 인증해주세요!")
        Text("휴대폰 번호로 간편하게 로그인해보세요.")
        PhoneVerificationView(store: phoneVerificationStore)
      }
      .padding(20)
      
      Spacer()
      
      NavigationLink(
        tag: State.Route.verificationNumberCheck,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          VerificationNumberCheckView(store: verificationNumberCheckStore)
        },
        label: EmptyView.init
      )
    }
  }
}

// MARK: - Store init
extension SignInView {
  private var phoneVerificationStore: Store<PhoneVerificationState, PhoneVerificationAction> {
    return store.scope(
      state: \.phoneVerficationState,
      action: Action.phoneVerficationAction
    )
  }
  
  private var verificationNumberCheckStore: Store<VerificationNumberCheckState, VerificationNumberCheckAction> {
    return store.scope(
      state: \.verificationNumberCheckState,
      action: Action.verificationNumberCheckAction
    )
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(
      store: .init(
        initialState: .init(),
        reducer: signInReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
