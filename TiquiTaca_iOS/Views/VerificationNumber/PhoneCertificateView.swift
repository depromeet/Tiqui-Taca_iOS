//
//  PhoneCertificateView.swift
//  SwiftUIPractice
//
//  Created by 송하경 on 2022/04/17.
//
import ComposableArchitecture
import SwiftUI

struct PhoneCertificateView: View {
  let store: Store<PhoneCertificateState, PhoneCertificateAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Spacer()
          VStack(alignment: .leading, spacing: 10) {
            Text("인증번호를 입력해주세요.")
            Text("\(viewStore.phoneNumber)로 전송된 인증번호 6자리를 입력하세요.\(viewStore.certificationCode)")
              .font(.caption2)
            
            OTPFieldView(
              store: store.scope(
                state: \.otpFieldState,
                action: PhoneCertificateAction.otpFieldAction
              )
            )
          }
          
          Spacer()
//          Button {
//            viewStore.send(.certificationButtonTapped)
//          }label: {
//            Text("인증하기")
//          }
//          .disabled(checkStates())
//          .opacity(checkStates() ? 0.4 : 1)
//          .buttonStyle(NormalButtonStyle())
//          .padding(20)
        }
      }
      .navigationBarHidden(true)
    }
  }
}

struct PhoneCertificateView_Previews: PreviewProvider {
  static var previews: some View {
    PhoneCertificateView(
      store: .init(
        initialState: .init(),
        reducer: phoneCertificateReducer,
        environment: PhoneCertificateEnvironment(
          authService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
