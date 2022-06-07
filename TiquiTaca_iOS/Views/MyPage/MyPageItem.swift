//
//  MyPageItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/26.
//

import SwiftUI
import ComposableArchitecture

struct MypageItem: View {
  typealias State = MyPageItemState
  typealias Action = MyPageItemAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let rowInfo: MyPageItemInfo
    let isAppAlarmOn: Bool
    
    init(state: State) {
      rowInfo = state.rowInfo!
      isAppAlarmOn = state.isAppAlarmOn
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    HStack {
      Image(viewStore.rowInfo.imageName)
      
      Text(viewStore.rowInfo.title)
        .font(.subtitle3)
        .foregroundColor(.black900)
      
      Toggle(
        "",
        isOn: viewStore.binding(
          get: \.isAppAlarmOn,
          send: Action.alarmToggle
        )
      )
      .toggleStyle(SwitchToggleStyle(tint: .blue900))
      .opacity(viewStore.rowInfo.toggleVisible ? 1 : 0)

        
      if viewStore.rowInfo.description != nil {
        Text("v. \(viewStore.rowInfo.description ?? "0")")
          .font(.subtitle3)
          .foregroundColor(.blue900)
          .frame(width: 80)
      }
    }
    .background(Color.white)
    .frame(maxWidth: .infinity)
    .onTapGesture(perform: {
      viewStore.send(.mypageItemTapped(viewStore.rowInfo.itemType))
    })
  }
}
