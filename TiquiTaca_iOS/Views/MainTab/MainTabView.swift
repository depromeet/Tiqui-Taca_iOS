//
//  TabView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
	private let store: Store<MainTabState, MainTabAction>
	
	init(store: Store<MainTabState, MainTabAction>) {
		self.store = store
		UITabBar.appearance().scrollEdgeAppearance = .init()
	}
	
	var body: some View {
		TabView {
			MapTab(store: store)
			ChatTab(store: store)
			MsgAndNotiTab(store: store)
			MyPageTab(store: store)
		}
	}
}

// MARK: MapTab
private struct MapTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    MapView(store: store.scope(
      state: \.mapFeature,
      action: MainTabAction.mapFeature
    ))
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("지도")
    }
  }
}

// MARK: ChatTab
private struct ChatTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    ChatView(store: store.scope(
      state: \.chatFeature,
      action: MainTabAction.chatFeature
    ))
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("채팅")
    }
  }
}

// MARK: NotiTab
private struct MsgAndNotiTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    MsgAndNotiView(store: store.scope(
      state: \.msgAndNotiFeature,
      action: MainTabAction.msgAndNotiFeature
    ))
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("쪽지 알림")
    }
  }
}

// MARK: MyPageTab
private struct MyPageTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    MyPageView(store: store.scope(
      state: \.myPageFeature,
      action: MainTabAction.myPageFeature
    ))
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("마이페이지")
    }
  }
}

// MARK: Preview
struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView(
      store: .init(
        initialState: MainTabState(
          mapFeature: MapState(),
          chatFeature: ChatState(),
          msgAndNotiFeature: MsgAndNotiState(),
          myPageFeature: MyPageState()
        ),
        reducer: mainTabReducer,
        environment: MainTabEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
