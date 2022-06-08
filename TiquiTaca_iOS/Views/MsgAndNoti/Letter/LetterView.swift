//
//  LetterView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import SwiftUI
import ComposableArchitecture

struct LetterView: View {
  typealias State = LetterState
  typealias Action = LetterAction
  
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
        Text("Message \(index)")
      }
    }
    .listStyle(.plain)
  }
}

struct LetterView_Previews: PreviewProvider {
  static var previews: some View {
    LetterView(
      store: .init(
        initialState: .init(),
        reducer: letterReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
