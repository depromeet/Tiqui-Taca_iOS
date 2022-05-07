//
//  SignInView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import SwiftUI

struct SignInView: View {
  let store: Store<SignInState, SignInAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
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
          tag: SignInState.Route.verificationNumberCheck,
          selection: viewStore.binding(
            get: \.route,
            send: SignInAction.setRoute
          ),
          destination: {
            VerificationNumberCheckView(store: verificationNumberCheckStore)
          },
          label: {
            EmptyView()
          }
        )
      }
    }
  }
}

// MARK: - Store init
extension SignInView {
  private var phoneVerificationStore: Store<PhoneVerificationState, PhoneVerificationAction> {
    return store.scope(
      state: \.phoneVerficationState,
      action: SignInAction.phoneVerficationAction
    )
  }
  
  private var verificationNumberCheckStore: Store<VerificationNumberCheckState, VerificationNumberCheckAction> {
    return store.scope(
      state: \.verificationNumberCheckState,
      action: SignInAction.verificationNumberCheckAction
    )
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(
      store: .init(
        initialState: SignInState(),
        reducer: signInReducer,
        environment: SignInEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
