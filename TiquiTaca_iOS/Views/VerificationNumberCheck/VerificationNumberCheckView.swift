//
//  VerificationNumberCheckView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import SwiftUI

struct VerificationNumberCheckView: View {
  let store: Store<VerificationNumberCheckState, VerificationNumberCheckAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .center, spacing: 66) {
        VStack(alignment: .center, spacing: 16) {
          Text("인증번호를 입력해주세요.")
          Text("\(viewStore.phoneNumber)로 전송된 인증번호 6자리를 입력하세요.\(viewStore.certificationCode)")
            .font(.caption2)
        }
        
        OTPFieldView(store: otpFieldStore)
        
        NavigationLink(
          tag: VerificationNumberCheckState.Route.termsOfService,
          selection: viewStore.binding(
            get: \.route,
            send: VerificationNumberCheckAction.setRoute
          ),
          destination: {
            TermsOfServiceView(store: termsOfServiceStore)
          },
          label: {
            Text("Next")
          }
        )
      }
    }
  }
}

// MARK: - Store init
extension VerificationNumberCheckView {
  private var otpFieldStore: Store<OTPFieldState, OTPFieldAction> {
    return store.scope(
      state: \.otpFieldState,
      action: VerificationNumberCheckAction.otpFieldAction
    )
  }
  
  private var termsOfServiceStore: Store<TermsOfServiceState, TermsOfServiceAction> {
    return store.scope(
      state: \.termsOfServiceState,
      action: VerificationNumberCheckAction.termsOfServiceAction
    )
  }
}

struct VerificationNumberCheckView_Previews: PreviewProvider {
  static var previews: some View {
    VerificationNumberCheckView(
      store: .init(
        initialState: .init(),
        reducer: verificationNumberCheckReducer,
        environment: VerificationNumberCheckEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
