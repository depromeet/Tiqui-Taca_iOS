//
//  ChatView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

private struct TabButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
	}
}

struct ChatView: View {
	var store: Store<ChatState, ChatAction>

	init(store: Store<ChatState, ChatAction>) {
		self.store = store
		config()
	}
	
	var body: some View {
		WithViewStore(self.store) { viewStore in
			NavigationView {
				VStack(spacing: 0) {
					CurrentChatView()
					SectionHeader(currentTabIdx: viewStore.binding(
						get: \.currentTabIdx,
						send: ChatAction.tabChange
					))
					List {
						ForEach(0..<40) { index in
							RoomListCell(index: index, type: viewStore.state.currentTabIdx == 0 ? .like : .popular)
								.listRowSeparator(.hidden)
								.listRowInsets(EdgeInsets())
						}
					}
				}
					.listStyle(.plain)
					.navigationBarTitleDisplayMode(.large)
					.navigationTitle("채팅방")
			}
		}
	}
	
	private func config() {
		let standardAppearance = UINavigationBarAppearance()
		standardAppearance.configureWithTransparentBackground()
		standardAppearance.backgroundColor = Color.black800.uiColor
		standardAppearance.largeTitleTextAttributes = [
			.foregroundColor: Color.white.uiColor,
			.font: UIFont.systemFont(ofSize: 24, weight: .bold)
		]
		standardAppearance.titleTextAttributes = [
			.foregroundColor: Color.white.uiColor,
			.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
		]
		UINavigationBar.appearance().standardAppearance = standardAppearance
		UINavigationBar.appearance().compactAppearance = standardAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
		UINavigationBar.appearance().layoutMargins.left = 24
		UINavigationBar.appearance().layoutMargins.bottom = 0
		
		if #available(iOS 15.0, *) {
			UITableView.appearance().sectionHeaderTopPadding = 0
		}
	}
}


// MARK: Current Chat
private struct CurrentChatView: View {
	var body: some View {
		VStack {
			VStack {
				Text("현재 참여 중인 채팅방")
					.hLeading()
					.foregroundColor(.green500)
					.font(.system(size: 14, weight: .bold, design: .default))
				
				Spacer().frame(height: 16)
				HStack(spacing: 4) {
					Text("서울 대학교")
						.foregroundColor(.white)
						.font(.system(size: 16, weight: .bold, design: .default))
					HStack(spacing: 0) {
						Image("people")
							.resizable()
							.frame(width: 24, height: 24)
						Text("300")
							.foregroundColor(.black100)
							.font(.system(size: 12, weight: .semibold, design: .default))
					}
					Text("오후 3:15")
						.foregroundColor(.black100)
						.font(.system(size: 11, weight: .semibold, design: .default))
						.hTrailing()
				}
					.hLeading()
				
				Spacer().frame(height: 4)
				HStack {
					Text("서울대학교에서 가장 맛있는 맛집 하나만 알려주실 분 궇요!")
						.foregroundColor(.white800)
						.font(.system(size: 12, weight: .semibold, design: .default))
						.lineLimit(1)
						.hLeading()
					VStack {
						Text("36")
							.font(.system(size: 13, weight: .semibold, design: .default))
							.foregroundColor(.black800)
							.padding([.leading, .trailing], 6)
							.padding([.top, .bottom], 2)
					}
						.background(Color.green900)
						.cornerRadius(11)
				}
					.hLeading()
			}
				.padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
				.background(Color.black600)
				.cornerRadius(16)
				.padding([.leading, .trailing], 24)
				.padding(.top, 16)
				.padding(.bottom, 18)
		}
			.background(Color.black800)
	}
}


// MARK: Section Header
private struct SectionHeader: View {
	@Binding var currentTabIdx: Int
	
	var body: some View {
		HStack(spacing: 0) {
			Spacer().frame(width: 10)
			
			Button(action: {
				currentTabIdx = 0
			}, label: {
				Text("즐겨찾기")
					.font(.system(size: 15, weight: .semibold, design: .default))
					.foregroundColor(Color.green500)
					.padding([.leading, .trailing], 14)
			})
				.frame(height: 40)
				.overlay(
					Rectangle()
						.frame(height: 2)
						.foregroundColor(Color.green500),
					alignment: .bottom)
			
			Button(action: {
				currentTabIdx = 1
			}, label: {
				Text("인기채팅방")
					.font(.system(size: 15, weight: .semibold, design: .default))
					.foregroundColor(Color.black100)
					.padding([.leading, .trailing], 14)
			})
				.frame(height: 40)
				.overlay(
					Rectangle()
						.frame(height: 0)
						.foregroundColor(Color.green500),
					alignment: .bottom)
			
			Spacer()
			Text("15:30 기준")
				.foregroundColor(.white800)
				.font(.system(size: 13, weight: .semibold, design: .default))
				.padding(.trailing, 24)
				.hTrailing()
		}
			.frame(height: 40)
			.background(Color.black800)
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
