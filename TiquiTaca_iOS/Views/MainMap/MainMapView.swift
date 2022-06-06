//
//  MainMapView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import MapKit
import ComposableArchitecture
import TTDesignSystemModule
import Map

struct MainMapView: View {
  typealias State = MainMapState
  typealias Action = MainMapAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let bottomSheetPosition: TTBottomSheet.Position
    let bottomSheetType: MainMapBottomSheetType
    let chatRoomAnnotationInfos: [RoomFromCategoryResponse]
    let region: MKCoordinateRegion
    let alert: AlertState<MainMapAction>?
    let chatRoomListState: ChatRoomListState
    let popularChatRoomListState: PopularChatRoomListState
    let selectedAnnotationOverlay: [MKCircle]
    
    init(state: State) {
      bottomSheetPosition = state.bottomSheetPosition
      bottomSheetType = state.bottomSheetType
      chatRoomAnnotationInfos = state.chatRoomAnnotationInfos
      region = state.region
      alert = state.alert
      chatRoomListState = state.chatRoomListState
      popularChatRoomListState = state.popularChatRoomListState
      selectedAnnotationOverlay = state.selectedAnnotationOverlay
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack {
      Map(
        coordinateRegion: viewStore.binding(
          get: \.region,
          send: Action.setRegion
        ),
        annotationItems: viewStore.chatRoomAnnotationInfos,
        annotationContent: { chatRoomInfo in
          ViewMapAnnotation(coordinate: chatRoomInfo.coordinate) {
            Button {
              viewStore.send(.annotationTapped(chatRoomInfo))
            } label: {
              ChatRoomAnnotationView(info: chatRoomInfo)
            }
          }
        },
        overlayItems: viewStore.selectedAnnotationOverlay,
        overlayContent: { overlay in
          RendererMapOverlay(overlay: overlay) { _, overlay in
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = Color.green500.uiColor
            circleRenderer.fillColor = Color.green900.uiColor.withAlphaComponent(0.3)
            circleRenderer.lineWidth = 1
            return circleRenderer
          }
        }
      )
      .offset(y: viewStore.bottomSheetPosition != .hidden ? -100 : 0)
      .animation(.default, value: viewStore.bottomSheetPosition != .hidden)
      .preferredColorScheme(.light)
      .edgesIgnoringSafeArea([.all])
      
      VStack {
        LocationCategoryListView(
          selectedCategory: viewStore.binding(
            get: \.chatRoomListState.listCategoryType,
            send: MainMapAction.categoryTapped
          )
        )
        Spacer()
        VStack {
          HStack(spacing: .spacingM) {
            Button {
              viewStore.send(.popularChatRoomButtonTapped)
            } label: {
              HStack(spacing: .spacingM) {
                Text("지금 인기있는 채팅방 알아보기")
                  .font(.body2)
                Image("popular")
              }
              .frame(width: 265, height: 48)
              .background(Color.black800)
              .cornerRadius(16)
              .foregroundColor(.white)
            }
            
            Button {
              viewStore.send(.currentLocationButtonTapped)
            } label: {
              Image("locationPolygon")
                .frame(width: 48, height: 48)
                .background(Color.black800)
                .cornerRadius(24)
            }
          }
          .hCenter()
          .padding(.bottom, .spacingL)
        }
        .padding(.horizontal, .spacingXL)
      }
    }
    .bottomSheet(
      bottomSheetPosition: viewStore.binding(
        get: \.bottomSheetPosition,
        send: Action.setBottomSheetPosition
      ),
      options: TTBottomSheet.Options
    ) {
      switch viewStore.bottomSheetType {
      case .chatRoomDetail:
        ChatRoomDetailView(store: chatRoomDetailStore)
      case .chatRoomList:
        ChatRoomListView(store: chatRoomListStore)
      case .popularChatRoomList:
        PopularChatRoomListView(store: popularChatRoomListStore)
      }
    }
    .alert(
      store.scope(state: { $0.alert }),
      dismiss: .dismissAlertButtonTapped
    )
    .onAppear {
      viewStore.send(.onAppear)
    }
    .navigationTitle("지도")
  }
}

// MARK: - Store init
extension MainMapView {
  private var chatRoomDetailStore: Store<ChatRoomDetailState, ChatRoomDetailAction> {
    return store.scope(
      state: \.chatRoomDetailState,
      action: Action.chatRoomDetailAction
    )
  }
  
  private var chatRoomListStore: Store<ChatRoomListState, ChatRoomListAction> {
    return store.scope(
      state: \.chatRoomListState,
      action: Action.chatRoomListAction
    )
  }
  
  private var popularChatRoomListStore: Store<PopularChatRoomListState, PopularChatRoomListAction> {
    return store.scope(
      state: \.popularChatRoomListState,
      action: Action.popularChatRoomListAction
    )
  }
}

struct MainMapView_Previews: PreviewProvider {
  static var previews: some View {
    MainMapView(
      store: .init(
        initialState: .init(),
        reducer: mainMapReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main,
          locationManager: .live
        )
      )
    )
  }
}
