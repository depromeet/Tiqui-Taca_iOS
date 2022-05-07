//
//  SignUpView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule
import SwiftUI

struct SignUpView: View {
  let store: Store<SignUpState, SignUpAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
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
          tag: SignUpState.Route.verificationNumberCheck,
          selection: viewStore.binding(
            get: \.route,
            send: SignUpAction.setRoute
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
extension SignUpView {
  private var phoneVerificationStore: Store<PhoneVerificationState, PhoneVerificationAction> {
    return store.scope(
      state: \.phoneVerficationState,
      action: SignUpAction.phoneVerficationAction
    )
  }
  
  private var verificationNumberCheckStore: Store<VerificationNumberCheckState, VerificationNumberCheckAction> {
    return store.scope(
      state: \.verificationNumberCheckState,
      action: SignUpAction.verificationNumberCheckAction
    )
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: .init(
        initialState: SignUpState(),
        reducer: signUpReducer,
        environment: SignUpEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
