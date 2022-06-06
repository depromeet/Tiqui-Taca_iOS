//
//  ChatRoomDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/06.
//

import SwiftUI
import CoreLocation
import ComposableArchitecture
import TTDesignSystemModule

struct ChatRoomDetailView: View {
  typealias State = ChatRoomDetailState
  typealias Action = ChatRoomDetailAction
  
  private let store: Store<State, Action>
  private var viewStore: ViewStore<ViewState, Action>
  
  private var distanceString: String {
    if viewStore.isWithinRadius {
      return "현재 이 채팅방의 반경 내에 위치해있어요!"
    } else {
      let distance = viewStore.chatRoom.distance(from: viewStore.currentLocation)
      return "현재 위치로부터 \(distance.prettyDistance) 떨어져있어요"
    }
  }
  
  struct ViewState: Equatable {
    let chatRoom: RoomFromCategoryResponse
    let currentLocation: CLLocation
    let isWithinRadius: Bool
    
    init(state: State) {
      chatRoom = state.chatRoom
      currentLocation = state.currentLocation
      isWithinRadius = state.isWithinRadius
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: .spacingXL) {
      VStack(spacing: .spacingXXS) {
        HStack(spacing: .spacingXS) {
          Text(viewStore.chatRoom.name)
            .font(.heading2)
            .foregroundColor(.white)
          Image(viewStore.chatRoom.isFavorite ? "favoriteActive" : "favoriteDisabled")
            .resizable()
            .frame(width: 24, height: 24)
        }
        Text(distanceString)
          .font(.body3)
          .foregroundColor(viewStore.isWithinRadius ? .green500 : .white800)
      }
      
      HStack(spacing: 57) {
        VStack(spacing: .spacingXXXS) {
          Text("카테고리")
            .font(.body7)
            .foregroundColor(.white800)
          Image(viewStore.chatRoom.category.imageName)
            .resizable()
            .frame(width: 48, height: 48)
          Text(viewStore.chatRoom.category.locationName)
            .font(.body2)
            .foregroundColor(.white)
        }
        VStack(spacing: .spacingXXXS) {
          Text("참여인원")
            .font(.body7)
            .foregroundColor(.white800)
          Image("peopleColor")
            .resizable()
            .frame(width: 48, height: 48)
          Text("\(viewStore.chatRoom.userCount)명")
            .font(.body2)
            .foregroundColor(.white)
        }
        VStack(spacing: .spacingXXXS) {
          Text("해당장소")
            .font(.body7)
            .foregroundColor(.white800)
          Image(viewStore.isWithinRadius ? "locationIn" : "locationOut")
            .resizable()
            .frame(width: 48, height: 48)
          Text(viewStore.isWithinRadius ? "반경 내" : "반경 외")
            .font(.body2)
            .foregroundColor(.white)
        }
      }
      Button {
        viewStore.send(.joinChatRoomButtonTapped)
      } label: {
        Text(viewStore.chatRoom.isJoin ? "현재 채팅방으로 돌아가기" : "새로운 채팅방 참여하기")
      }
      .buttonStyle(TTButtonLargeGreenStyle())
    }
    .padding(.horizontal, .spacingXL)
    .vCenter()
    .hCenter()
  }
}

struct ChatRoomDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ChatRoomDetailView(
      store: .init(
        initialState: .init(),
        reducer: chatRoomDetailReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
    .background(Color.black700)
    .previewLayout(.sizeThatFits)
  }
}
