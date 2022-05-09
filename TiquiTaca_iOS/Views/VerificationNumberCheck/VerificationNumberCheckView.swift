//
//  VerificationNumberCheckView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import SwiftUI
import ComposableArchitecture

struct VerificationNumberCheckView: View {
  typealias State = VerificationNumberCheckState
  typealias Action = VerificationNumberCheckAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route?
    let phoneNumber: String
    let expireMinute: Int
    
    init(state: State) {
      route = state.route
      phoneNumber = state.phoneNumber
      expireMinute = state.expireMinute
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 66) {
      VStack(alignment: .center, spacing: 16) {
        Text("인증번호를 입력해주세요.")
        Text("\(viewStore.phoneNumber)로 전송된 인증번호 6자리를 입력하세요.")
          .font(.caption2)
      }
      
      OTPFieldView(store: otpFieldStore)
      
      NavigationLink(
        tag: State.Route.termsOfService,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          TermsOfServiceView(store: termsOfServiceStore)
        },
        label: EmptyView.init
      )
    }
  }
}

// MARK: - Store init
extension VerificationNumberCheckView {
  private var otpFieldStore: Store<OTPFieldState, OTPFieldAction> {
    return store.scope(
      state: \.otpFieldState,
      action: Action.otpFieldAction
    )
  }
  
  private var termsOfServiceStore: Store<TermsOfServiceState, TermsOfServiceAction> {
    return store.scope(
      state: \.termsOfServiceState,
      action: Action.termsOfServiceAction
    )
  }
}

struct VerificationNumberCheckView_Previews: PreviewProvider {
  static var previews: some View {
    VerificationNumberCheckView(
      store: .init(
        initialState: .init(),
        reducer: verificationNumberCheckReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
