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
  @ObservedObject private var viewStore: ViewStore<ViewState, ChatAction>
  
  struct ViewState: Equatable {
    let enteredRoom: RoomInfoEntity.Response?
    let lastChatLog: ChatLogEntity.Response?
    let unReadChatCount: Int
    
    let currentTab: RoomListType
    let lastLoadTime: String
    let likeRoomList: [RoomInfoEntity.Response]
    let popularRoomList: [RoomInfoEntity.Response]
    
    let showRoomEnterPopup: Bool
    let moveToChatDetail: Bool
    let route: ChatState.Route?
    
    init(state: ChatState) {
      enteredRoom = state.enteredRoom
      lastChatLog = state.lastChatLog
      unReadChatCount = state.unReadChatCount
      
      currentTab = state.currentTab
      lastLoadTime = state.lastLoadTime
      likeRoomList = state.likeRoomList
      popularRoomList = state.popularRoomList
      
      showRoomEnterPopup = state.showRoomEnterPopup
      moveToChatDetail = state.moveToChatDetail
      route = state.route
    }
  }
  
  init(store: Store<ChatState, ChatAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: .spacingM) {
        title
        enteredRoomView
        tabKindView
      }
        .background(Color.black800)
      
      RoomListView(store: store)
        .background(.white)
      
      NavigationLink(
        tag: ChatState.Route.chatDetail,
        selection: viewStore.binding(
          get: \.route,
          send: ChatAction.setRoute
        ),
        destination: {
          ChatDetailView(
            store: store.scope(
              state: \.chatDetailState,
              action: ChatAction.chatDetailAction
            ),
            shouldPopToRootView: viewStore.binding (
              get: \.moveToChatDetail,
              send: ChatAction.setMoveToChatDetail
            )
          )
        },
        label: EmptyView.init
      )
        .isDetailLink(false)
        .frame(height: 0)
        .hidden()
//      NavigationLink(
//        destination: ChatDetailView(
//          store: store.scope(
//            state: \.chatDetailState,
//            action: ChatAction.chatDetailAction),
//          shouldPopToRootView: viewStore.binding(
//            get: \.moveToChatDetail,
//            send: ChatAction.setMoveToChatDetail
//          )
//        ),
//        isActive: viewStore.binding(
//          get: \.moveToChatDetail,
//          send: ChatAction.setMoveToChatDetail
//        )
//      ) { EmptyView() }
//        .isDetailLink(false)
//        .frame(height: 0)
//        .hidden()
    }
    .listStyle(.plain)
    .navigationTitle("채팅방")
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
}

// MARK: Title View
extension ChatView {
  var title: some View {
    Text("채팅방")
      .font(.heading1)
      .foregroundColor(.white)
      .padding(.horizontal, .spacingXL)
      .padding(.top, .spacingXL)
      .hLeading()
  }
}

// MARK: Entered Chat View
extension ChatView {
  var enteredRoomView: some View {
    VStack {
      VStack {
        if viewStore.enteredRoom == nil {
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
          VStack {
            Text("현재 참여 중인 채팅방")
              .hLeading()
              .foregroundColor(.green500)
              .font(.subtitle4)
            
            Spacer().frame(height: 16)
            HStack(spacing: 4) {
              Text(viewStore.enteredRoom?.name ?? "기타")
                .foregroundColor(.white)
                .font(.subtitle2)
              HStack(spacing: 0) {
                Image("people")
                  .resizable()
                  .frame(width: 24, height: 24)
                Text("\(viewStore.enteredRoom?.userCount ?? 0)")
                  .foregroundColor(.black100)
                  .font(.body7)
              }
              Text(viewStore.lastChatLog?.createdAt?.getTimeTodayOrDate() ?? "00:00")
                .foregroundColor(.black100)
                .font(.body8)
                .hTrailing()
            }
            .hLeading()
            
            Spacer().frame(height: 4)
            HStack {
              Text(
                viewStore.lastChatLog == nil ?
                "아직 아무도 채팅을 치지 않았어요" :
                  (viewStore.lastChatLog?.getMessage() ?? "")
              )
              .foregroundColor(.white800)
              .font(.body7)
              .lineLimit(1)
              .hLeading()
              VStack {
                Text(
                  viewStore.unReadChatCount >= 100 ?
                  "+99" :
                    "\(viewStore.unReadChatCount)"
                )
                .foregroundColor(viewStore.unReadChatCount == 0 ? Color.black600 : .black800)
                .font(.body4)
                .padding([.leading, .trailing], 6)
                .padding([.top, .bottom], 2)
              }
              .background(viewStore.unReadChatCount == 0 ? Color.black600 : Color.green900)
              .cornerRadius(11)
            }
            .hLeading()
          }
          .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
      }
      .background(Color.black600)
      .cornerRadius(16)
      .padding([.leading, .trailing], 24)
      .frame(height: 116)
      .onTapGesture {
        guard let room = viewStore.enteredRoom else { return }
        viewStore.send(.willEnterRoom(room))
        viewStore.send(.setRoute(.chatDetail))
      }
    }
  }
}

// MARK: Tab Kind View
extension ChatView {
  var tabKindView: some View {
    HStack(spacing: 0) {
      Spacer().frame(width: 10)
      Button(
        action: { viewStore.send(.tabChange(.like)) },
        label: { Text("즐겨찾기") }
      )
      .buttonStyle(TabButton())
      .disabled(viewStore.currentTab == .like)
      Button(
        action: { viewStore.send(.tabChange(.popular)) },
        label: { Text("인기채팅방") }
      )
      .buttonStyle(TabButton())
      .disabled(viewStore.currentTab == .popular)
      Text(viewStore.lastLoadTime + " 기준")
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
        alignment: .bottom
      )
  }
}


// MARK: RoomListView
private struct RoomListView: View {
  typealias CAction = ChatAction
  typealias CState = ChatState
  
  private let maxUserCount = 300
  private let store: Store<CState, CAction>
  @ObservedObject private var viewStore: ViewStore<ViewState, CAction>
    
  struct ViewState: Equatable {
    let roomType: RoomListType
    let likeRoomList: [RoomInfoEntity.Response]
    let popularRoomList: [RoomInfoEntity.Response]
    let enteredRoom: RoomInfoEntity.Response?
    
    let willEnterRoom: RoomInfoEntity.Response?
    let showRoomEnterPopup: Bool
    
    init(state: CState) {
      roomType = state.currentTab
      likeRoomList = state.likeRoomList
      popularRoomList = state.popularRoomList
      enteredRoom = state.enteredRoom
      
      willEnterRoom = state.willEnterRoom
      showRoomEnterPopup = state.showRoomEnterPopup
    }
  }
  
  init(store: Store<CState, CAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    List {
      if (viewStore.roomType == .like && viewStore.likeRoomList.isEmpty) ||
          (viewStore.roomType == .popular && viewStore.popularRoomList.isEmpty) {
        NoDataView(noDataType: viewStore.roomType)
          .padding(.top, .spacingXXXL * 2)
          .background(.white)
      } else {
        ForEach(
          (viewStore.roomType == .like ?
            viewStore.likeRoomList :
            viewStore.popularRoomList
          ).enumerated().map({ $0 }), id: \.element.id
        ) { index, room in
          RoomListCell(ranking: index + 1, info: room, type: viewStore.roomType)
            .background(.white)
            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
              if viewStore.roomType == .like {
                Button(
                  action: {
                    ViewStore(store).send(.removeFavoriteRoom(room))
                  },
                  label: { Text("삭제") }
                ).tint(.red)
              }
            })
            .onTapGesture(perform: {
              if viewStore.enteredRoom == nil || room.id == viewStore.enteredRoom?.id {
                viewStore.send(.willEnterRoom(room))
                viewStore.send(.setRoute(.chatDetail))
              } else {
                UIView.setAnimationsEnabled(false)
                viewStore.send(.willEnterRoom(room))
                viewStore.send(.setShowRoomEnterPopup(true))
              }
            })
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
      }
    }
      .fullScreenCover(
        isPresented: viewStore.binding(
          get: \.showRoomEnterPopup,
          send: ChatAction.setShowRoomEnterPopup
        )
      ) {
        if viewStore.willEnterRoom?.userCount ?? 0 >= maxUserCount {
          AlertView(store: store)
            .overCapacity
        } else {
          AlertView(store: store)
            .existEnteredRoom
        }
      }
      .refreshable {
        viewStore.send(.refresh)
      }
  }
}

// MARK: Alert
private struct AlertView: View {
  private let store: Store<ChatState, ChatAction>
  @ObservedObject var viewStore: ViewStore<ViewState, ChatAction>
  
  struct ViewState: Equatable {
    let showRoomEnterPopup: Bool
    let route: ChatState.Route?
    
    init(state: ChatState) {
      showRoomEnterPopup = state.showRoomEnterPopup
      route = state.route
    }
  }
  
  init(store: Store<ChatState, ChatAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    existEnteredRoom
  }
  
  var existEnteredRoom: some View {
    TTPopupView.init(
      popUpCase: .oneLineTwoButton,
      title: "이미 참여 중인 채팅방이 있어요",
      subtitle: "해당 채팅방을 참가할 경우 이전 채팅방에선 나가게 됩니다",
      leftButtonName: "취소",
      rightButtonName: "참여하기",
      confirm: {
        viewStore.send(.setShowRoomEnterPopup(false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true) 
          viewStore.send(.setRoute(.chatDetail))
        }
      },
      cancel: {
        viewStore.send(.setShowRoomEnterPopup(false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
      .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
      .background(BackgroundTransparentView())
  }
  
  var overCapacity: some View {
    TTPopupView.init(
      popUpCase: .oneLineTwoButton,
      title: "해당 채팅방은 인원이 가득 찼어요",
      subtitle: "최대 인원수 300명이 차서 입장이 불가능해요",
      leftButtonName: "닫기",
      cancel: {
        viewStore.send(.setShowRoomEnterPopup(false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
      .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
      .background(BackgroundTransparentView())
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

struct ChatView_Previews: PreviewProvider {
  static var previews: some View {
    ChatView(
      store: .init(
        initialState: ChatState(),
        reducer: chatReducer,
        environment: ChatEnvironment(
          appService: .init(),
          mainQueue: .main,
          locationManager: .live
        )
      )
    )
  }
}
