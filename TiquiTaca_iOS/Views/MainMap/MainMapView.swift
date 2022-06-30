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
    let isShowPopup: Bool
    let isMoveToChatDetail: Bool
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
      isShowPopup = state.isShowPopup
      isMoveToChatDetail = state.isMoveToChatDetail
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
      NavigationLink(
        isActive: viewStore.binding(
          get: \.isMoveToChatDetail,
          send: Action.setIsMoveToChatDetail
        ),
        destination: {
          IfLetStore(
            chatDetailStore,
            then: ChatDetailView.init
          )
        },
        label: EmptyView.init
      )
      
      Map(
        coordinateRegion: viewStore.binding(
          get: \.region,
          send: Action.setRegion
        ),
        informationVisibility: .userLocation,
        interactionModes: [.pan, .zoom, .rotate],
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
      .offset(y: viewStore.bottomSheetPosition != .hidden ? -120 : 0)
      .animation(.default, value: viewStore.bottomSheetPosition != .hidden)
      .preferredColorScheme(.light)
      .edgesIgnoringSafeArea([.all])
      .highPriorityGesture(
        TapGesture()
          .onEnded { _ in
            viewStore.send(.setBottomSheetPosition(.hidden))
          }
      )
      
      VStack(spacing: .spacingXXS) {
        LocationCategoryListView(
          selectedCategory: viewStore.binding(
            get: \.chatRoomListState.listCategoryType,
            send: MainMapAction.categoryTapped
          )
        )
        .frame(height: 60)
        
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
            Image("nearme")
              .resizable()
              .frame(width: 48, height: 48)
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
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        viewStore.send(.onAppear)
      }
    }
    .onLoad {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        viewStore.send(.onLoad)
      }
    }
    .navigationTitle("지도")
    .fullScreenCover(
      isPresented: viewStore.binding(
        get: \.isShowPopup,
        send: Action.setIsShowPopup
      )
    ) {
      AlertView(
        isPopupPresent: viewStore.binding(
          get: \.isShowPopup,
          send: Action.setIsShowPopup
        ),
        moveToChatDetailState: viewStore.binding(
          get: \.isMoveToChatDetail,
          send: Action.setIsMoveToChatDetail
        ),
        roomUserCount: viewStore.chatRoomDetailState.chatRoom.userCount
      )
      .background(BackgroundTransparentView())
    }
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
  
  private var chatDetailStore: Store<ChatDetailState?, ChatDetailAction> {
    return store.scope(
      state: \.chatDetailState,
      action: Action.chatDetailAction
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


// MARK: Alert
private struct AlertView: View {
  @Binding var isPopupPresent: Bool
  @Binding var moveToChatDetailState: Bool
  let roomUserCount: Int
  var maxUserCount = 300
  // 채팅방 인원 풀 -> 경고만
  // 채팅방 교체할 것인지 -> 경고 후 참가
  var body: some View {
    if roomUserCount < maxUserCount {
      existEnteredRoom
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
    } else {
      overCapacity
    }
  }
  
  var existEnteredRoom: some View {
    TTPopupView.init(
      popUpCase: .oneLineTwoButton,
      title: "이미 참여 중인 채팅방이 있어요",
      subtitle: "해당 채팅방을 참가할 경우 이전 채팅방에선 나가게 됩니다",
      leftButtonName: "취소",
      rightButtonName: "참여하기",
      confirm: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
          moveToChatDetailState = true
        }
      },
      cancel: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
  }
  
  var overCapacity: some View {
    TTPopupView.init(
      popUpCase: .oneLineTwoButton,
      title: "해당 채팅방은 인원이 가득 찼어요",
      subtitle: "최대 인원수 300명이 차서 입장이 불가능해요",
      leftButtonName: "닫기",
      confirm: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
        }
      },
      cancel: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
  }
}
