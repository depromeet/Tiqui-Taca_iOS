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
			ZStack {
				NavigationView {
					VStack(spacing: 0) {
						CurrentChatView(roomInfo: viewStore.state.enteredRoom)
						
						TabKindView(
							currentTab: viewStore.binding(
								get: \.currentTab,
								send: ChatAction.tabChange),
							currentTime: "13:15 기준"// viewStore.state.lastLoadTime
						)
						
						if viewStore.state.currentTab == .like {
							LikeRoomListView(store: store)
						} else {
							PopularRoomListView(store: store)
						}
					}
						.listStyle(.plain)
						.navigationBarTitleDisplayMode(.large)
						.navigationTitle("채팅방")
						.onAppear(perform: { viewStore.send(.onAppear) })
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
	let roomInfo: RoomInfoEntity.Response?
	
	var body: some View {
		VStack {
			VStack {
				if roomInfo == nil {
					VStack(spacing: 12) {
						Text("현재 참여 중인 채팅방이 없어요")
							.foregroundColor(.white800)
							.font(.subtitle2)
						Text("궁금한 장소에 대해 알아보고 싶으시면\n채팅방을 참여해보세요!")
							.lineLimit(2)
							.foregroundColor(.white800)
							.font(.body7)
							.multilineTextAlignment(.center)
					}
						.hCenter()
						.vCenter()
				} else {
					Text("현재 참여 중인 채팅방")
						.hLeading()
						.foregroundColor(.green500)
						.font(.subtitle4)

					Spacer().frame(height: 16)
					HStack(spacing: 4) {
						Text(roomInfo?.name ?? "기타")
							.foregroundColor(.white)
							.font(.subtitle2)
						HStack(spacing: 0) {
							Image("people")
								.resizable()
								.frame(width: 24, height: 24)
							Text("\(roomInfo?.userCount ?? 0)")
								.foregroundColor(.black100)
								.font(.body7)
						}
						Text("오후 3:15")
							.foregroundColor(.black100)
							.font(.body8)
							.hTrailing()
					}
						.hLeading()

					Spacer().frame(height: 4)
					HStack {
						Text("코엑스에서 가장 맛있는 맛집 하나만 알려주실 분 있나요!")
							.foregroundColor(.white800)
							.font(.body7)
							.lineLimit(1)
							.hLeading()
						VStack {
							Text("36")
								.foregroundColor(.black800)
								.font(.body4)
								.padding([.leading, .trailing], 6)
								.padding([.top, .bottom], 2)
						}
							.background(Color.green900)
							.cornerRadius(11)
					}
						.hLeading()
				}
			}
				.padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
				.background(Color.black600)
				.cornerRadius(16)
				.padding([.leading, .trailing], 24)
				.padding(.top, 16)
				.padding(.bottom, 18)
				.frame(height: 116 + 32)
		}
			.background(Color.black800)
	}
}


// MARK: Tab Kind View
private struct TabKindView: View {
	@Binding var currentTab: RoomListType
	let currentTime: String
	
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
			Text(currentTime)
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

// MARK: Room List
private struct RoomListView: View {
	private let store: Store<ChatState, ChatAction>
	private let roomType: RoomListType
	@Binding var roomList: [RoomInfoEntity.Response]
	@State var isPopupPresent: Bool = false
	
	var body: some View {
		Text("하이")
	}
}


private struct LikeRoomListView: View {
	private let store: Store<ChatState, ChatAction>
	
	init(store: Store<ChatState, ChatAction>) {
		self.store = store
	}
	
	var body: some View {
		WithViewStore(store.scope(state: \.likeRoomList)) { likeListViewStore in
			List {
				if likeListViewStore.state.isEmpty {
					NoDataView(noDataType: .like)
						.padding(.top, .spacingXXXL * 2)
				} else {
					ForEach(likeListViewStore.state, id: \.id) { room in
						RoomListCell(
							info: room,
							type: .like
						)
							.listRowSeparator(.hidden)
							.listRowInsets(EdgeInsets())
							.swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
								Button(
									action: { ViewStore(store).send(.removeFavoriteRoom(room)) },
									label: { Text("삭제") }
								).tint(.red)
							})
							.onTapGesture(perform: {
								ViewStore(store).send(.enterRoomPopup(room))
							})
					}
				}
			}
				.refreshable {
					ViewStore(store).send(.refresh)
				}
		}
	}
}

private struct PopularRoomListView: View {
	private let store: Store<ChatState, ChatAction>
	@State var isPopupPresent: Bool = false
	
	init(store: Store<ChatState, ChatAction>) {
		self.store = store
	}
	
	var body: some View {
    WithViewStore(store.scope(state: \.popularRoomList)) { viewStore in
      List {
        if viewStore.state.isEmpty {
          NoDataView(noDataType: .popular)
            .padding(.top, .spacingXXXL * 2)
        } else {
          ForEach(viewStore.state.enumerated().map { $0 }, id: \.element.id) { index, room in
            RoomListCell(ranking: index + 1, info: room, type: .popular )
              .listRowSeparator(.hidden)
              .listRowInsets(EdgeInsets())
              .onTapGesture {
                isPopupPresent = true
                ViewStore(store).send(.enterRoomPopup(room))
              }
          }
        }
      }
      .ttPopup(
        isShowing: $isPopupPresent
      ) {
        TTPopupView.init(
          popUpCase: .oneLineTwoButton,
          title: "이미 참여 중인 채팅방이 있어요",
          subtitle: "해당 채팅방을 참가할 경우 이전 채팅방에선 나가게 됩니다",
          leftButtonName: "취소",
          rightButtonName: "참여하기",
          confirm: { isPopupPresent = false },
          cancel: { isPopupPresent = false }
        )
      }
      .refreshable {
        ViewStore(store).send(.refresh)
      }
    }
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
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets())
			.vCenter()
			.hCenter()
	}
}

// MARK: Enter Room Alert
private struct EnterRoomAlertView: View {
	@Binding var isPresent: Bool
	var body: some View {
		VStack { }
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
