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

struct ChatView: View {
	var store: Store<ChatState, ChatAction>

	init(store: Store<ChatState, ChatAction>) {
		self.store = store
		config()
	}
	
	var body: some View {
		WithViewStore(self.store) { viewStore in
			NavigationView {
				ZStack {
					VStack(spacing: 0) {
						CurrentChatView()
						
						TabKindView(
							currentTab: viewStore.binding(
								get: \.currentTab,
								send: ChatAction.tabChange
						))
						
						List {
							if viewStore.state.presentRoomList.isEmpty {
								NoDataView(noDataType: viewStore.state.currentTab)
									.listRowSeparator(.hidden)
									.listRowInsets(EdgeInsets())
									.padding(.top, .spacingXXXL * 2)
							} else {
								ForEach(viewStore.state.presentRoomList, id: \.id) { room in
									RoomListCell(
										index: 1,
										info: room,
										type: viewStore.state.currentTab
									)
										.listRowSeparator(.hidden)
										.listRowInsets(EdgeInsets())
										.swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
											if viewStore.state.currentTab == .like {
												Button(
													action: { viewStore.send(.removeFavoriteRoom(room)) },
													label: { Text("삭제") }
												)
													.tint(.red)
											}
										})
										.onTapGesture(perform: {
											viewStore.send(.presentEnterRoomPopup(room))
										})
								}
							}
						}
							.refreshable {
								viewStore.send(.refresh)
							}
					}
						.listStyle(.plain)
						.navigationBarTitleDisplayMode(.large)
						.navigationTitle("채팅방")
						.onAppear(perform: {
							viewStore.send(.fetchPopularRoomList)
						})
					
					TTPopupView.init(
						popUpCase: .oneLineTwoButton,
						topImageString: "",
						title: "이미 참여 중인 채팅방이 있어요",
						subtitle: "해당 채팅방을 참가할 경우 이전 채팅방에선 나가게 됩니다",
						leftButtonName: "취소",
						rightButtonName: "참여하기",
						confirm: {
							viewStore.send(.dismissPopup)
						},
						cancel: {
							viewStore.send(.dismissPopup)
						}
					)
						.opacity(viewStore.popupPresented ? 1 : 0)
				}
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


// MARK: Current Chat View
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


// MARK: Tab Kind View
private struct TabKindView: View {
	@Binding var currentTab: RoomListType
	
	var body: some View {
		HStack(spacing: 0) {
			Spacer().frame(width: 10)
			Button(
				action: { currentTab = .like },
				label: { Text("즐겨찾기") }
			)
				.buttonStyle(TabButton())
				.disabled(currentTab == .like)
			Button(
				action: { currentTab = .popular },
				label: { Text("인기채팅방") }
			)
				.buttonStyle(TabButton())
				.disabled(currentTab == .popular)
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

private struct TabButton: ButtonStyle {
	@Environment(\.isEnabled) var isEnabled
	
	public init() { }
	
	public func makeBody(configuration: Configuration) -> some View {
		return configuration.label
			.frame(height: 40)
			.font(.subtitle3)
			.foregroundColor(isEnabled ? .black100 : .green500)
			.padding([.leading, .trailing], 14)
			.overlay(
				Rectangle()
					.frame(height: isEnabled ? 0 : 2)
					.foregroundColor(Color.green500),
				alignment: .bottom)
	}
}

// MARK: NoData View
private struct NoDataView: View {
	let noDataType: RoomListType
	var body: some View {
		VStack(spacing: .spacingS) {
			Image(noDataType == .like ? "noFavorite" : "noData")
			Text(noDataType == .like ?
				"즐겨찾기로 설정한 채팅방이 없어요" :
				"아직 활발하게 티키타카하는 곳이 없어요.\n원하는 채팅방에 먼저 참여해보세요!"
			)
				.font(.body2)
				.foregroundColor(.white900)
				.multilineTextAlignment(.center)
				.lineSpacing(.spacingXXS)
		}
			.vCenter()
			.hCenter()
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
