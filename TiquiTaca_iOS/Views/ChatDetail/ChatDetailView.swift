//
//  ChatDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//

import SwiftUI

struct ChatDetailView: View {
	var body: some View {
    VStack {
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
      
      //키보드
    }
	}
}

struct ChatDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ChatDetailView()
	}
}
