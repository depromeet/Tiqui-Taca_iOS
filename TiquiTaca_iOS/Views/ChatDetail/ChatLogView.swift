//
//  ChatLogView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ChatLogView: View {
  typealias State = ChatLogState
  typealias Action = ChatLogAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let roomName: String
    let roomAlarm: Bool
    let participantCount: Int
    let chatLogList: [ChatLogEntity.Response]
    
    init(state: State) {
      roomName = state.roomName
      roomAlarm = state.roomAlarm
      participantCount = state.participantCount
      chatLogList = state.chatLogList
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      
    }
    .background(Color.white)
    .ignoresSafeArea()
  }
}

struct ChatLogView_Previews: PreviewProvider {
  static var previews: some View {
    ChatLogView(
      store: .init(
        initialState: ChatLogState(chatLogList: []),
        reducer: chatLogReducer,
        environment: ChatLogEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
