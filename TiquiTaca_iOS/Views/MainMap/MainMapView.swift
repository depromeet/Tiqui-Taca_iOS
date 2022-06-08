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
  
  var showSpreadButton: Bool {
    return viewStore.bottomSheetType != .popularChatRoomList
    && viewStore.bottomSheetPosition == .hidden
  }
  
  struct ViewState: Equatable {
    let bottomSheetPosition: TTBottomSheet.Position
    let bottomSheetType: MainMapBottomSheetType
    let chatRoomAnnotationInfos: [RoomFromCategoryResponse]
    let region: MKCoordinateRegion
    let alert: AlertState<MainMapAction>?
    let chatRoomListState: ChatRoomListState
    let popularChatRoomListState: PopularChatRoomListState
    let chatRoomDetailState: ChatRoomDetailState
    let selectedAnnotationOverlay: [MKCircle]
    let userTrackingMode: State.MapUserTrackingModeType
    
    init(state: State) {
      bottomSheetPosition = state.bottomSheetPosition
      bottomSheetType = state.bottomSheetType
      chatRoomAnnotationInfos = state.chatRoomAnnotationInfos
      region = state.region
      alert = state.alert
      chatRoomListState = state.chatRoomListState
      popularChatRoomListState = state.popularChatRoomListState
      selectedAnnotationOverlay = state.selectedAnnotationOverlay
      userTrackingMode = state.userTrackingMode
      chatRoomDetailState = state.chatRoomDetailState
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
        informationVisibility: .default.union(.userLocation),
        userTrackingMode: viewStore.binding(
          get: \.userTrackingMode,
          send: Action.setUserTrackingMode
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
            if viewStore.chatRoomDetailState.isWithinRadius {
              circleRenderer.strokeColor = Color.green500.uiColor
              circleRenderer.fillColor = Color.green900.uiColor.withAlphaComponent(0.3)
            } else {
              circleRenderer.strokeColor = Color.white50.uiColor
              circleRenderer.fillColor = Color.white800.uiColor.withAlphaComponent(0.4)
            }
            circleRenderer.lineWidth = 1
            return circleRenderer
          }
        }
      )
      .offset(y: viewStore.bottomSheetPosition != .hidden ? -100 : 0)
      .animation(.default, value: viewStore.bottomSheetPosition != .hidden)
      .preferredColorScheme(.light)
      .edgesIgnoringSafeArea([.all])
      
      VStack(spacing: .spacingM) {
        LocationCategoryListView(
          selectedCategory: viewStore.binding(
            get: \.chatRoomListState.listCategoryType,
            send: MainMapAction.categoryTapped
          )
        )
        if showSpreadButton {
          Button {
            viewStore.send(.setBottomSheetPosition(.middle))
          } label: {
            HStack {
              Text("리스트 펼쳐보기")
                .font(.body2)
                .foregroundColor(.black800)
              Image("arrowDown")
                .resizable()
                .frame(width: 16, height: 16)
            }
            .padding(.horizontal, .spacingM)
            .padding(.vertical, .spacingXS)
            .background(Color.white50)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
          }
        }
        Spacer()
        HStack(spacing: .spacingM) {
          Button {
            viewStore.send(.popularChatRoomButtonTapped)
          } label: {
            HStack(spacing: .spacingM) {
              Text("지금 인기있는 채팅방 알아보기")
                .font(.body2)
                .foregroundColor(.white)
              Image("bxPopular")
                .resizable()
                .frame(width: 48, height: 48)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.black800)
            .cornerRadius(16)
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
        .padding(.horizontal, .spacingXL)
        .padding(.bottom, .spacingL)
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
    .onLoad {
      viewStore.send(.onLoad)
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
