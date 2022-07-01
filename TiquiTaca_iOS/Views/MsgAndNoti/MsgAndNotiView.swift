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
    
    init(state: State) {
      selectedType = state.selectedType
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
          viewStore.send(.setSelectedType(.letter))
        } label: {
          Text("쪽지함")
            .font(.heading1)
            .foregroundColor(viewStore.selectedType == .letter ? .black800 : .white800)
        }
        .padding(.trailing, 20)
        
        Button {
          viewStore.send(.setSelectedType(.notification))
        } label: {
          Text("알림")
            .font(.heading1)
            .foregroundColor(viewStore.selectedType == .notification ? .black800 : .white800)
        }
        Spacer()
        if viewStore.selectedType == .notification {
          Button {
            viewStore.send(.notificationAction(.setReadAllNotification))
          } label: {
            Text("모두 읽음")
              .font(.subtitle4)
              .foregroundColor(.white800)
          }
        }
      }
      .padding(.spacingXL)
      
      switch viewStore.selectedType {
      case .letter:
        LetterView(store: letterStore)
      case .notification:
        NotificationView(store: notificationStore)
      }
    }
    .navigationTitle("쪽지·알림")
  }
}

extension MsgAndNotiView {
  private var letterStore: Store<LetterState, LetterAction> {
    return store.scope(
      state: \.letterState,
      action: Action.letterAction
    )
  }
  private var notificationStore: Store<NotificationState, NotificationAction> {
    return store.scope(
      state: \.notificationState,
      action: Action.notificationAction
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
