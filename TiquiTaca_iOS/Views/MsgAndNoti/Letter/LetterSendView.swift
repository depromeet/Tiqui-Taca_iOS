//
//  LetterSendView.swift
//  TiquiTaca_iOS
//
//  Created by hakyung on 2022/06/10.
//

import SwiftUI
import TTDesignSystemModule
import ComposableArchitecture

struct LetterSendView: View {
  typealias State = LetterSendState
  typealias Action = LetterSendAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @FocusState private var focusedField: Bool
  
  struct ViewState: Equatable {
    let sendingUser: UserEntity.Response?
    let inputLetterString: String
    let popupPresented: Bool
    let sendLetterSuccess: Bool
    let toastPresented: Bool
    
    init(state: State) {
      sendingUser = state.sendingUser
      inputLetterString = state.inputLetterString
      popupPresented = state.popupPresented
      sendLetterSuccess = state.sendLetterSuccess
      toastPresented = state.toastPresented
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  
  var body: some View {
    VStack {
      topNavigationView
      ZStack(alignment: .leading) {
        TextEditor(
          text: viewStore.binding(
            get: \.inputLetterString ,
            send: LetterSendAction.inputLetterTyping
          )
        )
        .font(.body4)
        .focused($focusedField)
        
        VStack {
          Text(
            viewStore.inputLetterString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
            "텍스트를 입력해주세요" : ""
          )
          .foregroundColor(Color.black100)
          .font(.body4)
          .hLeading()
          .padding(4.5)
          
          Spacer()
        }
      }
      .padding([.top, .bottom], 16)
      .padding([.leading, .trailing], 24)
    }
    .ttPopup(
      isShowing: viewStore.binding(
        get: \.popupPresented,
        send: LetterSendAction.dismissPopup
      ),
      topImageString: "bxPaperplane"
    ) {
      TTPopupView.init(
        popUpCase: .twoLineTwoButton,
        title: "\(viewStore.sendingUser?.nickname ?? "")님께\n쪽지를 보내시겠어요?",
        leftButtonName: "취소",
        rightButtonName: "보내기",
        confirm: {
          viewStore.send(.sendLetter)
        },
        cancel: {
          viewStore.send(.dismissPopup)
        }
      )
    }
    .popup(
      isPresented: viewStore.binding(
        get: \.toastPresented,
        send: LetterSendAction.dismissToast
      ),
      type: .floater(
        verticalPadding: 16,
        useSafeAreaInset: true
      ),
      position: .top,
      animation: .easeIn,
      autohideIn: 2
    ) {
      TTToastView(
        title: "쪽지를 보낼 수 없는 사용자에요.",
        type: .error
      )
      .padding(.top, .spacingS)
    }
    .onChange(of: viewStore.sendLetterSuccess) { sendLetterSuccess in
      if sendLetterSuccess {
        self.presentationMode.wrappedValue.dismiss()
      }
    }
    .navigationBarHidden(true)
    .ignoresSafeArea(.all, edges: .top)
    .hideKeyboardWhenTappedAround()
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("arrowBack")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color.black500)
            .frame(width: 24, height: 24)
          Spacer()
        }
        .frame(width: 72)
        
        Spacer()
        
        Text("쪽지 보내기")
          .font(.subtitle2)
          .foregroundColor(.black800)
        
        Spacer()
        
        Button {
          //          presentationMode.wrappedValue.dismiss()
          focusedField = false
          viewStore.send(.presentPopup)
        } label: {
          Text("보내기")
        }
        .buttonStyle(TTButtonSmallStyle())
        .frame(width: 72, height: 36)
        .disabled(viewStore.inputLetterString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.white)
    .frame(height: 88)
  }
}

struct LetterSendView_Previews: PreviewProvider {
  static var previews: some View {
    LetterSendView(
      store: .init(
        initialState: .init(),
        reducer: letterSendReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
