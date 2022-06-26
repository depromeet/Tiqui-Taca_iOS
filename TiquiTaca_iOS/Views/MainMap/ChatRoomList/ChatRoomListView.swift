//
//  ChatRoomListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/05.
//

import SwiftUI
import CoreLocation
import ComposableArchitecture
import TTDesignSystemModule

struct ChatRoomListView: View {
  typealias State = ChatRoomListState
  typealias Action = ChatRoomListAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  var distanceColor: Color {
    if viewStore.listSortType == .distance {
      return .white
    } else {
      return .black100
    }
  }
  var popularColor: Color {
    if viewStore.listSortType == .popular {
      return .white
    } else {
      return .black100
    }
  }
  
  struct ViewState: Equatable {
    let listSortType: ChatRoomListSortType
    let listCategoryType: LocationCategory
    let chatRoomList: [RoomFromCategoryResponse]
    let isLoading: Bool
    let currentLocation: CLLocation
    
    init(state: State) {
      listSortType = state.listSortType
      listCategoryType = state.listCategoryType
      chatRoomList = state.chatRoomList
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
          HStack(spacing: .spacingXXS) {
            Image(viewStore.listCategoryType.imageName)
              .resizable()
              .frame(width: 40, height: 40)
            Text(viewStore.listCategoryType.locationName)
              .font(.subtitle1)
              .foregroundColor(.green500)
            Text("\(viewStore.chatRoomList.count)")
              .font(.subtitle2)
              .foregroundColor(.black100)
          }
          Spacer()
          HStack(spacing: .spacingS) {
            Button {
              viewStore.send(.setListSortType(.distance))
            } label: {
              Text("거리순")
                .foregroundColor(distanceColor)
            }
            Button {
              viewStore.send(.setListSortType(.popular))
            } label: {
              Text("인기순")
                .foregroundColor(popularColor)
            }
          }
          .font(.body2)
        }
        .padding(.horizontal, .spacingXL)
        .padding(.top, .spacingXL)
        ZStack {
          List {
            ForEach(viewStore.chatRoomList) { element in
              Button {
                viewStore.send(.itemSelected(element))
              } label: {
                ChatRoomListItem(
                  roomInfo: element,
                  currentLocation: viewStore.currentLocation
                )
              }
              .listRowSeparatorTint(.black600)
              .listRowBackground(Color.clear)
              .deleteDisabled(viewStore.listCategoryType != .favorite)
            }
            .onDelete { offsets in
              viewStore.send(.deleteItem(offsets))
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init())
          }
          .listStyle(.plain)
          .overlay(alignment: .top) {
            Rectangle()
              .fill(Color.black600)
              .frame(height: 1)
          }
          if viewStore.chatRoomList.isEmpty {
            VStack(spacing: .spacingS) {
              Image("bxInfoArrow")
                .resizable()
                .frame(width: 108, height: 108)
              Text("해당 카테고리의 채팅방이 아직 존재하지 않아요")
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

struct ChatRoomListView_Previews: PreviewProvider {
  static var previews: some View {
    ChatRoomListView(
      store: .init(
        initialState: .init(),
        reducer: chatRoomListReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
