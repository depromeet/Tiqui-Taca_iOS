//
//  MainMapCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import MapKit
import ComposableArchitecture
import ComposableCoreLocation

struct MainMapState: Equatable {
  var bottomSheetPosition: TTBottomSheet.Position = .hidden
  var bottomSheetType: MainMapBottomSheetType = .popularChatRoomList
  var chatRoomAnnotationInfos: [ChatRoomAnnotationInfo] = []
  var selectedAnnotationId: String?
  var region: MKCoordinateRegion = .init()
  var alert: AlertState<MainMapAction>?
  var isRequestingCurrentLocation: Bool = false
  
  var popularChatRoomListState: PopularChatRoomListState = .init()
  // var roomDetailState: RoomDetailState = .init()
  // var chatRoomListState: ChatRoomListState = .init()
}

enum MainMapAction: Equatable {
  case locationManager(LocationManager.Action)
  case onAppear
  case setBottomSheetPosition(TTBottomSheet.Position)
  case setBottomSheetType(MainMapBottomSheetType)
  case setSelectedAnnotationId(String?)
  case updateRegion(MKCoordinateRegion)
  case currentLocationButtonTapped
  case dismissAlertButtonTapped
  case popularChatRoomButtonTapped
  
  case popularChatRoomListAction(PopularChatRoomListAction)
//  case roomDetailAction(RoomDetailListAction)
//  case chatRoomListAction(ChatRoomListAction)
}

struct MainMapEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var locationManager: LocationManager
}

let mainMapReducer = Reducer<
  MainMapState,
  MainMapAction,
  MainMapEnvironment
>.combine([
  locationManagerReducer
    .pullback(
      state: \.self,
      action: /MainMapAction.locationManager,
      environment: { $0 }
    ),
  popularChatRoomListReducer
    .pullback(
      state: \.popularChatRoomListState,
      action: /MainMapAction.popularChatRoomListAction,
      environment: {
        PopularChatRoomListEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  mainMapCore
])

let mainMapCore = Reducer<
  MainMapState,
  MainMapAction,
  MainMapEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    return .merge(
      environment.locationManager
        .delegate()
        .map(MainMapAction.locationManager),
      environment.locationManager
        .requestWhenInUseAuthorization()
        .fireAndForget(),
      environment.locationManager
        .startMonitoringSignificantLocationChanges()
        .fireAndForget()
    )
    
  case .currentLocationButtonTapped:
    guard environment.locationManager.locationServicesEnabled() else {
      state.alert = .init(title: TextState("설정에서 위치 권한 사용을 허용해주세요."))
      return .none
    }
    
    switch environment.locationManager.authorizationStatus() {
    case .restricted, .denied:
      state.alert = .init(title: TextState("설정에서 위치 권한 사용을 허용해주세요."))
      return .none
    case .notDetermined:
      return environment.locationManager
        .requestWhenInUseAuthorization()
        .fireAndForget()
    case .authorizedAlways, .authorizedWhenInUse:
      state.isRequestingCurrentLocation = true
      return environment.locationManager
        .requestLocation()
        .fireAndForget()
    default:
      return .none
    }
    
  case let .setBottomSheetPosition(position):
    if state.bottomSheetType == .popularChatRoomList && position == .top {
      return .none
    }
    state.bottomSheetPosition = position
    return .none
    
  case let .setBottomSheetType(type):
    state.bottomSheetType = type
    return .none
    
  case let .setSelectedAnnotationId(id):
    state.selectedAnnotationId = id
    return .none
    
  case let .updateRegion(region):
    state.region = region
    return .none
    
  case .locationManager:
    return .none
    
  case .dismissAlertButtonTapped:
    state.alert = nil
    return .none
    
  case let .popularChatRoomListAction(.itemSelected(element)):
    // detail 띄우기
    return .none
    
  case let .popularChatRoomListAction(.getRoomListResponse(.success(roomList))):
    guard let roomList = roomList else { return .none }
    state.chatRoomAnnotationInfos = roomList
      .compactMap { element -> ChatRoomAnnotationInfo in
        return element.toChatRoomAnnotationInfo()
      }
    return .none
    
  case .popularChatRoomListAction:
    return .none
    
  case .popularChatRoomButtonTapped:
    return .merge([
      .init(value: .setBottomSheetType(.popularChatRoomList)),
      .init(value: .popularChatRoomListAction(.requestChatRoomList)),
      .init(value: .setBottomSheetPosition(.middle))
    ])
  }
}

private let locationManagerReducer = Reducer<
  MainMapState,
  LocationManager.Action,
  MainMapEnvironment
> { state, action, environment in
  switch action {
//  case .didChangeAuthorization(.authorizedAlways),
//      .didChangeAuthorization(.authorizedWhenInUse):
//    if state.isRequestingCurrentLocation {
//      return environment.locationManager
//        .requestLocation()
//        .fireAndForget()
//    }
//    return .none
    
  case .didChangeAuthorization(.denied),
      .didChangeAuthorization(.restricted):
    state.alert = .init(title: TextState("위치 서비스 설정이 허용되어야 정상적인 사용이 가능합니다."))
    return .none
    
  case let .didUpdateLocations(locations):
    guard let location = locations.first else { return .none }
    if state.isRequestingCurrentLocation {
      state.isRequestingCurrentLocation = false
      state.region = MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )
    }
    state.popularChatRoomListState.currentLocation = location.rawValue
    // state.roomDetailState.currentLocation = location.rawValue
    // state.chatRoomListState.currentLocation = location.rawValue
    return .none
    
  default:
    return .none
  }
}
