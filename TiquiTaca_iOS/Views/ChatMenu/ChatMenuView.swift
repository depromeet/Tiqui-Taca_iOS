//
//  ChatMenuView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ChatMenuView: View {
  typealias State = ChatMenuState
  typealias Action = ChatMenuAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let roomName: String
    let participantCount: Int
    let questionCount: Int
    let questionList: [QuestionEntity.Response]
    
    init(state: State) {
      roomName = state.roomName
      participantCount = state.participantCount
      questionCount = state.questionCount
      questionList = state.questionList
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      VStack {
        HStack {
          Button {
            
          } label: {
            Image("chat_backButton")
          }
          
          Text(viewStore.roomName)
            .foregroundColor(Color.white)
          Text("+ \(viewStore.participantCount)")
            .foregroundColor(Color.white)
          
          Spacer()
          
          Button {
            viewStore.send(.roomExit)
          } label: {
            Image("chat_exit")
          }
        }
        .padding([.leading, .trailing], 10)
        .padding(.top, 54)
        .padding(.bottom, 10)
      }
      .background(Color.black800)
      .frame(height: 88)
      
      Spacer()
      
      VStack(alignment: .leading) {
        Text("최근 등록된 질문")
          .font(.heading3)
          .foregroundColor(.black800)
        Text("총 \(viewStore.questionCount)개의 질문")
          .font(.body7)
          .foregroundColor(.black100)
        
        List {
          ForEach(viewStore.questionList) { question in
            
          }
          
        }
      }
      
    }
    .background(Color.white)
    .ignoresSafeArea()
  }
}

struct ChatMenuView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMenuView(
      store: .init(
        initialState: ChatMenuState(),
        reducer: chatMenuReducer,
        environment: ChatMenuEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
