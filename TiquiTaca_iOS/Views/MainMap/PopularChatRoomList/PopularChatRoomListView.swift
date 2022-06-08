//
//  PopularChatRoomListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import SwiftUI
import CoreLocation
import ComposableArchitecture
import TTDesignSystemModule

struct PopularChatRoomListView: View {
  typealias State = PopularChatRoomListState
  typealias Action = PopularChatRoomListAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let popularList: [RoomFromCategoryResponse]
    let isLoading: Bool
    let currentLocation: CLLocation
    
    init(state: State) {
      popularList = state.popularList
      isLoading = state.isLoading
      currentLocation = state.currentLocation
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HStack {
          Text("실시간 인기있는 채팅방들")
            .font(.subtitle2)
            .foregroundColor(.green500)
          Spacer()
          Image("bxPopular")
            .resizable()
            .frame(width: 72, height: 72)
        }
        .padding(.horizontal, .spacingXL)
        ZStack {
          ScrollView {
            ForEach(Array(viewStore.popularList.enumerated()), id: \.element.id) { index, element in
              Button {
                viewStore.send(.itemSelected(element))
              } label: {
                PopularChatRoomListItem(
                  roomInfo: element,
                  rankingNumber: index + 1,
                  currentLocation: viewStore.currentLocation
                )
              }
            }
          }
          if viewStore.popularList.isEmpty {
            VStack(spacing: .spacingS) {
              Image("bxInfoArrow")
                .resizable()
                .frame(width: 108, height: 108)
              Text("아직 활발하게 티키타카하는 곳이 없어요.\n원하는 채팅방에 먼저 참여해보세요!")
                .font(.body2)
                .foregroundColor(.black100)
                .multilineTextAlignment(.center)
            }
            .padding(.bottom, 80)
          }
        }
      }
      TTIndicator(
        style: .medium,
        isAnimating: viewStore.binding(
          get: \.isLoading,
          send: Action.setLoading
        )
      )
    }
    .vCenter()
    .hCenter()
  }
}

struct PopularChatRoomListView_Previews: PreviewProvider {
  static var previews: some View {
    PopularChatRoomListView(
      store: .init(
        initialState: .init(),
        reducer: popularChatRoomListReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
