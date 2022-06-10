//
//  SendLetterView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/10.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct SendLetterView: View {
  typealias SLState = SendLetterState
  typealias Action = SendLetterAction
  
  var store: Store<SLState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @State var typingText: String = ""
  
  struct ViewState: Equatable {
    init(state: SLState) {
    }
  }
  
  init(store: Store<SLState, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      TextEditor(text: $typingText)
    }
    .ignoresSafeArea(.all, edges: .top)
      .vTop()
      .hCenter()
      .overlay(navigationView, alignment: .top)
  }
}

struct SendLetterView_Previews: PreviewProvider {
  static var previews: some View {
    SendLetterView(store: .init(
      initialState: SendLetterState(userId: ""),
      reducer: sendLetterReducer,
      environment: SendLetterEnvironment(
        appService: .init(),
        mainQueue: .main
      )
    ))
  }
}


// MARK: Overlay View
extension SendLetterView {
  var navigationView: some View {
    VStack {
      HStack {
        Button {
          self.presentationMode.wrappedValue.dismiss()
        } label: {
          Image("arrowBack")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color.black500)
            .frame(width: 24, height: 24)
        }
        
        Spacer()
        
        Text("쪽지 보내기")
          .font(.subtitle2)
          .foregroundColor(.black800)
        
        Spacer()
        
        Button {
          self.presentationMode.wrappedValue.dismiss()
        } label: {
          HStack(spacing: 10) {
            Image("arrowBack")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(.white)
              .frame(width: 24, height: 24)
          }
        }
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.white)
    .frame(height: 88)
  }
}
