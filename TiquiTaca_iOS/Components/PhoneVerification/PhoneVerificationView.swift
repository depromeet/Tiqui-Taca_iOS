//
//  PhoneVerificationView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct PhoneVerificationView: View {
  let store: Store<PhoneVerificationState, PhoneVerificationAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 46) {
        VStack(spacing: .spacingXS) {
          TextField(
            "휴대폰 번호를 입력해주세요.",
            text: viewStore.binding(
              get: \.phoneNumber,
              send: PhoneVerificationAction.phoneNumberInput
            )
          )
          .padding(.top, .spacingXXL)
          .keyboardType(.numberPad)
          .foregroundColor(viewStore.isAvailablePhoneNumber ? .green500 : .white)
          
          Divider()
            .frame(height: .spacingXXXS)
            .background(viewStore.isAvailablePhoneNumber ? Color.green500 : Color.white700)
            .padding(.bottom, .spacingL)
        }
        
        Button {
          viewStore.send(.verificationButtonTap)
        } label: {
          Text("인증 번호 요청하기")
            .font(.subtitle1)
        }
        .buttonStyle(TTButtonLargeGreenStyle())
        .disabled(!viewStore.isAvailablePhoneNumber)
      }
    }
  }
}
