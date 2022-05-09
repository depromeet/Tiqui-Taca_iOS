//
//  ChatView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct ChatView: View {
  let store: Store<ChatState, ChatAction>
  
  var body: some View {
    WithViewStore(self.store) { _ in
      Text("ChatTab")
    }
  }
}

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(
      store: .init(
        initialState: ChatState(),
        reducer: chatReducer,
        environment: ChatEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
