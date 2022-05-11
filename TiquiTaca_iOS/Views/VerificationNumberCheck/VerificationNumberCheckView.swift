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
  @Environment(\.presentationMode) var presentationMode
  
  struct ViewState: Equatable {
    let route: State.Route?
    let phoneNumber: String
    let expireSeconds: Int
    let isAvailable: Bool
    
    init(state: State) {
      route = state.route
      phoneNumber = state.phoneNumber
      expireSeconds = state.expireSeconds
      isAvailable = state.isAvailable
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 66) {
      VStack(spacing: .spacingM) {
        Text("인증번호를 입력해주세요.")
          .foregroundColor(.white)
          .font(.heading1)
          .hLeading()
        Text("\(viewStore.phoneNumber)로 전송된 인증번호 6자리를 입력하세요.")
          .foregroundColor(.white600)
          .font(.body3)
          .hLeading()
      }
      .padding(.horizontal, .spacingXL)
      
      OTPFieldView(store: otpFieldStore)
      
      HStack {
        Text(viewStore.expireSeconds.timeString)
          .foregroundColor(viewStore.isAvailable ? Color.green600 : Color.errorRed)
          .font(.body3)
        Spacer()
        Button {
          viewStore.send(.requestAgain)
        } label: {
          Text("다시 요청하기")
            .foregroundColor(.white800)
            .font(.subtitle4)
        }
      }
      .padding(.horizontal, .spacingXL)
      
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
    .vCenter()
    .background(Color.black800)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("leftArrow")
        }
      }
    }
    .onAppear {
      viewStore.send(.timerStart)
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

// MARK: - Preview
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
