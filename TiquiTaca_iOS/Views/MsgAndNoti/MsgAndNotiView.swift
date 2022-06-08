//
//  MsgAndNotiView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MsgAndNotiView: View {
  typealias State = MsgAndNotiState
  typealias Action = MsgAndNotiAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let selectedType: MsgAndNotiType
    let messageState: MessageState
    
    init(state: State) {
      selectedType = state.selectedType
      messageState = state.messageState
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      HStack {
        Button {
          viewStore.send(.setSelectedType(.message))
        } label: {
          Text("쪽지함")
            .font(.heading1)
            .foregroundColor(viewStore.selectedType == .message ? .black800 : .white800)
        }
        Button {
          viewStore.send(.setSelectedType(.notification))
        } label: {
          Text("알림")
            .font(.heading1)
            .foregroundColor(viewStore.selectedType == .notification ? .black800 : .white800)
        }
        Spacer()
        Button {
        } label: {
          Text("모두 읽음")
            .font(.subtitle4)
            .foregroundColor(.white800)
        }
      }
      .padding(.spacingXL)
      
      switch viewStore.selectedType {
      case .message:
        MessageView(store: messageStore)
      case .notification:
        EmptyView()
      }
    }
    .navigationTitle("쪽지·알림")
  }
}

extension MsgAndNotiView {
  private var messageStore: Store<MessageState, MessageAction> {
    return store.scope(
      state: \.messageState,
      action: Action.messageAction
    )
  }
}

struct MsgAndNotiView_Previews: PreviewProvider {
  static var previews: some View {
    MsgAndNotiView(
      store: .init(
        initialState: .init(),
        reducer: msgAndNotiReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
