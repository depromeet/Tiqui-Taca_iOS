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
  typealias State = PhoneVerificationState
  typealias Action = PhoneVerificationAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let isAvailablePhoneNumber: Bool
    let phoneNumber: String
    
    init(state: State) {
      isAvailablePhoneNumber = state.isAvailablePhoneNumber
      phoneNumber = state.phoneNumber
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 46) {
      VStack(spacing: .spacingXS) {
        TextField(
          "",
          text: viewStore.binding(
            get: \.phoneNumber,
            send: PhoneVerificationAction.phoneNumberInput
          )
        )
        .placeholder(when: viewStore.phoneNumber.isEmpty) {
          Text("휴대폰 번호를 입력해주세요.")
            .foregroundColor(.white800)
        }
        .padding(.top, .spacingXXL)
        .keyboardType(.numberPad)
        .foregroundColor(viewStore.isAvailablePhoneNumber ? .green500 : .white)
        .font(.heading2)
        
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
