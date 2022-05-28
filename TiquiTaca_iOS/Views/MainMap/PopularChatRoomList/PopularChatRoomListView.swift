//
//  PopularChatRoomListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import SwiftUI
import ComposableArchitecture

struct PopularChatRoomListView: View {
  typealias State = PopularChatRoomListState
  typealias Action = PopularChatRoomListAction
  
  private let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    
    init(state: State) {
      
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      HStack {
        Text("실시간 인기있는 채팅방들")
        Image("popular")
      }
//      ScrollView {
//        
//      }
    }
  }
}

struct PopularChatRoomListView_Previews: PreviewProvider {
  static var previews: some View {
    PopularChatRoomListView(
      store: .init(
        initialState: .init(),
        reducer: popularChatRoomListReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
