//
//  NotificationView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import SwiftUI

import SwiftUI
import ComposableArchitecture

struct NotificationView: View {
  typealias State = NotificationState
  typealias Action = NotificationAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    
    init(state: State) {
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    List(selection: .constant(1)) {
      ForEach(0...10, id: \.self) { index in
        Text("Notification \(index)")
      }
    }
    .listStyle(.plain)
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
