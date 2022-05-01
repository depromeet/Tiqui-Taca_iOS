//
//  SignInView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import TTNetworkModule
import SwiftUI

struct SignInView: View {
  let store: Store<SignInState, SignInAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Text("로그인을 위해\n휴대폰 번호를 인증해주세요!")
            Text("휴대폰 번호로 간편하게 로그인해보세요.")
            PhoneVerificationView(
              store: store.scope(
                state: \.phoneVerficationState,
                action: SignInAction.phoneVerficationAction
              )
            )
          }
          .padding(20)
          
          Spacer()
          
          NavigationLink(
            isActive: viewStore.binding(
              get: \.isPhoneCertificateViewPresent,
              send: SignInAction.setIsPhoneCertificateViewPresent
            ),
            destination: {
              VerificationNumberCheckView(
                store: store.scope(
                  state: \.phoneCertificateState,
                  action: SignInAction.phoneCertificateAction
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

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView(
      store: .init(
        initialState: SignInState(),
        reducer: signInReducer,
        environment: SignInEnvironment(
          authService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
