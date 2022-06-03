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
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        VStack(spacing: .spacingM) {
          Text("채팅방")
            .font(.heading1)
            .foregroundColor(.white)
            .padding(.horizontal, .spacingXL)
            .padding(.top, .spacingXL)
            .hLeading()
          
          EnteredChatView(roomInfo: viewStore.state.enteredRoom)
          
          TabKindView(
            currentTab: viewStore.binding(
              get: \.currentTab,
              send: ChatAction.tabChange),
            currentTime: viewStore.state.lastLoadTime
          )
        }
        .background(Color.black800)
        
        if viewStore.state.currentTab == .like {
          LikeRoomListView(store: store)
            .background(.white)
        } else {
          PopularRoomListView(store: store)
            .background(.white)
        }
      }
      .preferredColorScheme(.dark)
      .listStyle(.plain)
      .navigationTitle("채팅방")
      .onAppear(perform: { viewStore.send(.onAppear) })
    }
  }
}

// MARK: Current Chat View
private struct EnteredChatView: View {
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
      .background(Color.black600)
      .cornerRadius(16)
      .padding([.leading, .trailing], 24)
      .frame(height: 116)
    }
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
      Text(currentTime + " 기준")
        .foregroundColor(.white800)
        .font(.system(size: 13, weight: .semibold, design: .default))
        .padding(.trailing, 24)
        .hTrailing()
    }
    .frame(height: 40)
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

// MARK: RoomList View
private struct LikeRoomListView: View {
  private let store: Store<ChatState, ChatAction>
  @State var isPopupPresent: Bool = false
  @State private var moveToChatDetailState: Bool = false
  
  init(store: Store<ChatState, ChatAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.likeRoomList)) { likeListViewStore in
      List {
        if likeListViewStore.state.isEmpty {
          NoDataView(noDataType: .like)
            .padding(.top, .spacingXXXL * 2)
            .background(.white)
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
      .fullScreenCover(isPresented: $isPopupPresent) {
        AlertView(isPopupPresent: $isPopupPresent, moveToChatDetailState: $moveToChatDetailState)
          .background(BackgroundTransparentView())
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
  @State private var moveToChatDetailState: Bool = false
  
  init(store: Store<ChatState, ChatAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store.scope(state: \.popularRoomList)) { viewStore in
      List {
        if viewStore.state.isEmpty {
          NoDataView(noDataType: .popular)
            .padding(.top, .spacingXXXL * 2)
            .background(.white)
        } else {
          ForEach(viewStore.state.enumerated().map { $0 }, id: \.element.id) { index, room in
            VStack(spacing: 0) {
              RoomListCell(ranking: index + 1, info: room, type: .popular )
                .background(.white)
                .onTapGesture {
                  UIView.setAnimationsEnabled(false)
                  isPopupPresent = true
                  ViewStore(store).send(.enterRoomPopup(room))
                }
              
              NavigationLink(isActive: $moveToChatDetailState) {
                ChatDetailView(
                  store: store.scope(
                    state: \.chatDetailState,
                    action: ChatAction.chatDetailAction
                  )
                )
              } label: {
              }
            }
              .listRowSeparator(.hidden)
              .listRowInsets(EdgeInsets())
          }
        }
      }
      .fullScreenCover(isPresented: $isPopupPresent) {
        AlertView(isPopupPresent: $isPopupPresent, moveToChatDetailState: $moveToChatDetailState)
          .background(BackgroundTransparentView())
      }
      .refreshable {
        ViewStore(store).send(.refresh)
      }
    }
  }
}


// MARK: Alert
private struct AlertView: View {
  @Binding var isPopupPresent: Bool
  @Binding var moveToChatDetailState: Bool
  
  // 이미 참여중인 채팅방 or 참여중인 채팅방 없음 -> 바로 Detail로
  // 채팅방 인원 풀 -> 경고만
  // 채팅방 교체할 것인지 -> 경고 후 참가
  var body: some View {
    TTPopupView.init(
      popUpCase: .oneLineTwoButton,
      title: "이미 참여 중인 채팅방이 있어요",
      subtitle: "해당 채팅방을 참가할 경우 이전 채팅방에선 나가게 됩니다",
      leftButtonName: "취소",
      rightButtonName: "참여하기",
      confirm: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.setAnimationsEnabled(true)
          moveToChatDetailState = true
        }
      },
      cancel: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
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

// MARK: Trasnparent Background
struct BackgroundTransparentView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = Color.black900.opacity(0.7).uiColor
    }
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}
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
