//
//  SignUpView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
  typealias State = SignUpState
  typealias Action = SignUpAction
  
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
        Text("회원가입을 위해\n휴대폰 번호를 인증해주세요!")
        Text("최초 인증과 티키타카의 회원이 되기 위해 필요해요.")
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
extension SignUpView {
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

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: .init(
        initialState: .init(),
        reducer: signUpReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
