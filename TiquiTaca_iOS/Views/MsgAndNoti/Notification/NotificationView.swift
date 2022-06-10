//
//  NotificationView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct NotificationView: View {
  typealias State = NotificationState
  typealias Action = NotificationAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let isLoading: Bool
    let isInfiniteScrollLoading: Bool
    let notifications: [NotificationResponse]
    let lastId: String?
    let isLast: Bool
    
    init(state: State) {
      isLoading = state.isLoading
      isInfiniteScrollLoading = state.isInfiniteScrollLoading
      notifications = state.notifications
      lastId = state.lastId
      isLast = state.isLast
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack {
      List {
        ForEach(viewStore.notifications) { item in
          Button {
            viewStore.send(.notificationTapped(item))
          } label: {
            NotificationItem(notification: item)
          }
          .listRowSeparator(.hidden)
          .listRowInsets(.init())
          .onAppear {
            if item.id == viewStore.lastId && !viewStore.isLast {
              viewStore.send(.loadMoreNotifications)
            }
          }
        }
        if viewStore.isInfiniteScrollLoading {
          ProgressView()
        }
      }
      .listStyle(.plain)
      .refreshable {
        viewStore.send(.getNotifications)
      }
      TTIndicator(
        style: .medium,
        color: .black,
        isAnimating: viewStore.binding(
          get: \.isLoading,
          send: Action.setIsLoading
        )
      )
    }
    .onLoad {
      viewStore.send(.getNotifications)
    }
  }
}

struct NotificationView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationView(
      store: .init(
        initialState: .init(),
        reducer: notificationReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
