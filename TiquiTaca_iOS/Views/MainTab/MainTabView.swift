//
//  TabView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
  typealias State = MainTabState
  typealias Action = MainTabAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let selectedTab: TabViewType
    
    init(state: State) {
      selectedTab = state.selectedTab
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
    
    let appearance = UITabBarAppearance()
    let tabBar = UITabBar()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Color.white.uiColor
    tabBar.standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some View {
    NavigationView {
      TabView(
        selection: viewStore.binding(
          get: \.selectedTab,
          send: MainTabAction.setSelectedTab
        )
      ) {
        MainMapView(store: mainMapViewStore)
          .tag(TabViewType.map)
          .tabItem {
            VStack {
              Text("지도")
              Image(viewStore.selectedTab == .map ? "map_active" : "map")
            }
          }
        ChatView(store: chatViewStore)
          .tag(TabViewType.chat)
          .tabItem {
            VStack {
              Text("채팅")
              Image(viewStore.selectedTab == .chat ? "chat_active" : "chat")
            }
          }
        MsgAndNotiView(store: msgAndNotiViewStore)
          .tag(TabViewType.msgAndNoti)
          .tabItem {
            VStack {
              Text("쪽지·알림")
              Image(viewStore.selectedTab == .msgAndNoti ? "letter_active" : "letter")
            }
          }
        MyPageView(store: myPageViewStore)
          .tag(TabViewType.myPage)
          .tabItem {
            VStack {
              Text("마이페이지")
              Image(viewStore.selectedTab == .myPage ? "mypage_active" : "mypage")
            }
          }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarHidden(true)
    }
    .navigationViewStyle(.stack)
    .onAppear {
      viewStore.send(.onAppear)
    }
    .onLoad {
      viewStore.send(.onLoad)
    }
  }
}

// MARK: - Store init
extension MainTabView {
  private var mainMapViewStore: Store<MainMapState, MainMapAction> {
    return store.scope(
      state: \.mainMapState,
      action: Action.mainMapAction
    )
  }
  
  private var chatViewStore: Store<ChatState, ChatAction> {
    return store.scope(
      state: \.chatState,
      action: Action.chatAction
    )
  }
  
  private var msgAndNotiViewStore: Store<MsgAndNotiState, MsgAndNotiAction> {
    return store.scope(
      state: \.msgAndNotiState,
      action: Action.msgAndNotiAction
    )
  }
  
  private var myPageViewStore: Store<MyPageState, MyPageAction> {
    return store.scope(
      state: \.myPageState,
      action: Action.myPageAction
    )
  }
}

// MARK: Preview
struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView(
      store: .init(
        initialState: .init(),
        reducer: mainTabReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main,
          locationManager: .live,
          deeplinkManager: .shared
        )
      )
    )
  }
}
