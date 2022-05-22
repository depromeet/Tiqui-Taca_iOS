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

struct MainMapView: View {
  typealias State = MainMapState
  typealias Action = MainMapAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let isPresentBottomSheet: Bool
    let chatRoomAnnotationInfos: [ChatRoomAnnotationInfo]
    let selectedAnnotationId: String?
    let region: MKCoordinateRegion
    
    init(state: State) {
      isPresentBottomSheet = state.isPresentBottomSheet
      chatRoomAnnotationInfos = state.chatRoomAnnotationInfos
      selectedAnnotationId = state.selectedAnnotationId
      region = state.region
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack {
      ZStack {
        Map(
          coordinateRegion: viewStore.binding(
            get: \.region,
            send: Action.updateRegion
          ),
          annotationItems: viewStore.chatRoomAnnotationInfos,
          annotationContent: { chatRoomInfo in
            MapAnnotation(coordinate: chatRoomInfo.coordinate) {
              ChatRoomAnnotationView(info: chatRoomInfo)
                .onTapGesture {
                  viewStore.send(.setSelectedAnnotationId(chatRoomInfo.id))
                }
            }
          }
        )
        .edgesIgnoringSafeArea([.all])
        
        VStack {
          // 상단 리스트
          
          Spacer()
          
          // 하단 버튼
          HStack(spacing: .spacingM) {
            Button {
              viewStore.send(.setPresentBottomSheet(true))
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
      
      TTBottomSheetView(
        isOpen: viewStore.binding(
          get: \.isPresentBottomSheet,
          send: Action.setPresentBottomSheet
        ),
        minHeight: 0,
        maxHeight: 328
      ) {
        // types:
        // popular chat room list
        // chat room list // category, favorite
        // room detail
      }
    }
    .onAppear {
      viewStore.send(.onAppear)
    }
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
          mainQueue: .main
        )
      )
    )
  }
}