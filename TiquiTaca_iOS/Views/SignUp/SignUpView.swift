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
      NavigationView {
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Text("회원가입을 위해\n휴대폰 번호를 인증해주세요!")
            Text("최초 인증과 티키타카의 회원이 되기 위해 필요해요.")
            PhoneVerificationView(
              store: store.scope(
                state: \.phoneVerficationState,
                action: SignUpAction.phoneVerficationAction
              )
            )
          }
          .padding(20)
          
          Spacer()
          
          NavigationLink(
            isActive: viewStore.binding(
              get: \.isNextViewPresent,
              send: { SignUpAction.setIsNextViewPresent($0) }
            ),
            destination: {
              PhoneCertificateView(
                store: store.scope(
                  state: \.phoneCertificateState,
                  action: SignUpAction.phoneCertificateAction
                )
              )
            },
            label: {
              EmptyView()
            }
          )
        }
      }
    }
  }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: .init(
        initialState: SignUpState(),
        reducer: signUpReducer,
        environment: SignUpEnvironment(
          authService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
