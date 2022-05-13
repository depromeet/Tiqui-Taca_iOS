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
  @State var selection: Int = 0
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
    
    let appearance = UITabBarAppearance()
    let tabBar = UITabBar()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Color.white.uiColor
    tabBar.standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  var body: some View {
    TabView(selection: $selection) {
      MapTab(store: store)
        .tabItem {
          TabViewItem(type: .map(selection == 0))
        }
        .tag(0)
      ChatTab(store: store)
        .tabItem {
          TabViewItem(type: .chat(selection == 1))
        }
        .tag(1)
      MsgAndNotiTab(store: store)
        .tabItem {
          TabViewItem(type: .msgAndNoti(selection == 2))
        }
        .tag(2)
      MyPageTab(store: store)
        .tabItem {
          TabViewItem(type: .myPage(selection == 3))
        }
        .tag(3)
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
    MainMapView(
      store: store.scope(
        state: \.mainMapFeature,
        action: MainTabAction.mainMapFeature
      )
    )
  }
}

// MARK: ChatTab
private struct ChatTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    ChatView(
      store: store.scope(
        state: \.chatFeature,
        action: MainTabAction.chatFeature
      )
    )
  }
}

// MARK: NotiTab
private struct MsgAndNotiTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    MsgAndNotiView(
      store: store.scope(
        state: \.msgAndNotiFeature,
        action: MainTabAction.msgAndNotiFeature
      )
    )
  }
}

// MARK: MyPageTab
private struct MyPageTab: View {
  private let store: Store<MainTabState, MainTabAction>
  
  init(store: Store<MainTabState, MainTabAction>) {
    self.store = store
  }
  
  var body: some View {
    MyPageView(
      store: store.scope(
        state: \.myPageFeature,
        action: MainTabAction.myPageFeature
      )
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
          mainQueue: .main
        )
      )
    )
  }
}
