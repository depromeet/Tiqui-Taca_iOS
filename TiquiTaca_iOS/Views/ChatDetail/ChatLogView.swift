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
      List {
        ForEach(viewStore.chatLogList) { chatlog in
          ChatMessageView(
            store: .init(
              initialState: .init(),
              reducer: chatMessageReducer,
              environment: ChatMessageEnvironment()
            )
          )
          .receivedBubble
        }
      }
      .listStyle(.plain)
      
      
//      VStack {
//        HStack {
//          Button {
//
//          } label: {
//            Image("chat_backButton")
//          }
//
//          Text(viewStore.roomName)
//            .foregroundColor(Color.white)
//          Text("+ \(viewStore.participantCount)")
//            .foregroundColor(Color.white)
//
//          Spacer()
//
//          Button {
//            viewStore.send(.roomAlamOff)
//          } label: {
//            Image(viewStore.roomAlarm ? "alarmOn" : "alarmOff")
//              .resizable()
//              .frame(width: 24, height: 24)
//          }
//
//          Button {
//            viewStore.send(.chatMenuClicked)
//          } label: {
//            Image("menu")
//              .resizable()
//              .frame(width: 24, height:24)
//          }
//        }
//        .padding([.leading, .trailing], 10)
//        .padding(.top, 54)
//        .padding(.bottom, 10)
//      }
//      .background(Color.black800.opacity(0.95))
//      .frame(height: 88)
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
