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
			NavigationView {
				List {
					VStack {
						Text("채팅방")
					}
					.frame(height: 150)
					.hCenter()
					.background(.gray)
					.cornerRadius(16)
					.listRowSeparator(.hidden)

					Section(header: HStack {
						Text("즐겨찾기")
							.font(.system(size: 15))
						Text("인기채팅방")
							.font(.system(size: 15))
						Spacer()
					}) {
						ForEach(1..<40) { index in
							Text("Row #\(index)")
								.listRowSeparator(.hidden)
						}
					}
				}
				.listStyle(.plain)
				.navigationBarTitle("채팅방")
				.navigationBarHidden(false)
				.navigationBarTitleDisplayMode(.automatic)
			}
			
			
			
			
		}
	}
}

struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
		ChatView(store: .init(
			initialState: ChatState(),
			reducer: chatReducer,
			environment: ChatEnvironment())
		)
	}
}
