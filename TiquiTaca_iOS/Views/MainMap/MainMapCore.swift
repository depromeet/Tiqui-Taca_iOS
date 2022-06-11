//
//  MainMapCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import Map
import MapKit
import ComposableArchitecture
import ComposableCoreLocation

struct MainMapState: Equatable {
  typealias MapUserTrackingModeType = MapUserTrackingMode // Map 네이밍 중복 문제
  
  var bottomSheetPosition: TTBottomSheet.Position = .hidden
  var bottomSheetType: MainMapBottomSheetType = .popularChatRoomList
  var chatRoomAnnotationInfos: [RoomFromCategoryResponse] = []
  var region: MKCoordinateRegion = .init()
  var alert: AlertState<MainMapAction>?
  var isRequestingCurrentLocation: Bool = false
  var selectedAnnotationOverlay: [MKCircle] = []
  var userTrackingMode: MapUserTrackingModeType = .none
  var isFirstLoad: Bool = false
  
  var chatRoomListState: ChatRoomListState = .init()
  var popularChatRoomListState: PopularChatRoomListState = .init()
  var chatRoomDetailState: ChatRoomDetailState = .init()
  
  var isShowPopup: Bool = false
  var isMoveToChatDetail: Bool = false
  var chatDetailState: ChatDetailState?
}

enum MainMapAction: Equatable {
  case locationManager(LocationManager.Action)
  case onAppear
  case onLoad
  case setBottomSheetPosition(TTBottomSheet.Position)
  case setBottomSheetType(MainMapBottomSheetType)
  case annotationTapped(RoomFromCategoryResponse)
  case setRegion(MKCoordinateRegion)
  case currentLocationButtonTapped
  case dismissAlertButtonTapped
  case popularChatRoomButtonTapped
  case categoryTapped(LocationCategory)
  case setUserTrackingMode(MapUserTrackingMode)
  
  case chatRoomListAction(ChatRoomListAction)
  case popularChatRoomListAction(PopularChatRoomListAction)
  case chatRoomDetailAction(ChatRoomDetailAction)
  
  case setIsShowPopup(Bool)
  case setIsMoveToChatDetail(Bool)
  case chatDetailAction(ChatDetailAction)
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
  chatRoomDetailReducer
    .pullback(
      state: \.chatRoomDetailState,
      action: /MainMapAction.chatRoomDetailAction,
      environment: {
        ChatRoomDetailEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  chatRoomListReducer
    .pullback(
      state: \.chatRoomListState,
      action: /MainMapAction.chatRoomListAction,
      environment: {
        ChatRoomListEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
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
  chatDetailReducer
    .optional()
    .pullback(
      state: \.chatDetailState,
      action: /MainMapAction.chatDetailAction,
      environment: {
        ChatDetailEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue,
          locationManager: $0.locationManager
        )
      }
    ),
  mainMapCore
])

private struct CancelRegionId: Hashable {}

private let mainMapCore = Reducer<
  MainMapState,
  MainMapAction,
  MainMapEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    return .merge([
      environment.locationManager
        .delegate()
        .map(MainMapAction.locationManager),
      environment.locationManager
        .requestWhenInUseAuthorization()
        .fireAndForget(),
      environment.locationManager
        .startMonitoringSignificantLocationChanges()
        .fireAndForget()
    ])
    
  case .onLoad:
    state.isFirstLoad = true
    return .init(value: .currentLocationButtonTapped)
    
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
      return .merge([
        .init(value: .setUserTrackingMode(.follow)),
        environment.locationManager
          .requestLocation()
          .fireAndForget()
      ])
    default:
      return .none
    }
    
  case let .locationManager(.didUpdateLocations(locations)):
    guard let location = locations.first else { return .none }
    if state.isRequestingCurrentLocation {
      state.isRequestingCurrentLocation = false
      state.region = MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )
    }
    state.chatRoomListState.currentLocation = location.rawValue
    state.popularChatRoomListState.currentLocation = location.rawValue
    state.chatRoomDetailState.currentLocation = location.rawValue
    
    if state.isFirstLoad {
      state.isFirstLoad = false
      return .merge([
        .init(value: .popularChatRoomListAction(.requestChatRoomList)),
        .init(value: .chatRoomDetailAction(.checkCurrentLocationWithinRadius))
      ])
    }
    
    return .init(value: .chatRoomDetailAction(.checkCurrentLocationWithinRadius))
    
  case .locationManager:
    return .none
    
  case let .setBottomSheetPosition(position):
    if state.bottomSheetType != .chatRoomList && position == .top {
      return .none
    }
    state.bottomSheetPosition = position
    return .none
    
  case let .setBottomSheetType(type):
    state.bottomSheetType = type
    return .none
    
  case let .annotationTapped(annotation):
    let overlay = MKCircle(center: annotation.coordinate, radius: annotation.radius)
    let focusRegion = MKCoordinateRegion(
      center: annotation.coordinate,
      span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    let monitoringRegion = Region(rawValue: annotation.geofenceRegion)
    state.selectedAnnotationOverlay = [overlay]
    state.chatRoomDetailState.chatRoom = annotation
    
    return .merge([
      .init(value: .chatRoomDetailAction(.checkCurrentLocationWithinRadius)),
      .init(value: .setRegion(focusRegion)),
      .init(value: .setBottomSheetType(.chatRoomDetail)),
      .init(value: .setBottomSheetPosition(.middle))
    ])
    
  case let .setRegion(region):
    state.region = region
    return .none
    
  case .dismissAlertButtonTapped:
    state.alert = nil
    return .none
    
  case .popularChatRoomButtonTapped:
    return .merge([
      .init(value: .setBottomSheetType(.popularChatRoomList)),
      .init(value: .setBottomSheetPosition(.middle))
    ])
    
  case let .categoryTapped(category):
    if category == .all {
      return .merge([
        .init(value: .popularChatRoomButtonTapped),
        .init(value: .popularChatRoomListAction(.requestChatRoomList)),
        .init(value: .chatRoomListAction(.setListCategoryType(category)))
      ])
    } else {
      return .merge([
        .init(value: .setBottomSheetType(.chatRoomList)),
        .init(value: .setBottomSheetPosition(.middle)),
        .init(value: .chatRoomListAction(.setListCategoryType(category)))
      ])
    }
    
  case let .setUserTrackingMode(mode):
    state.userTrackingMode = mode
    return .none
    
  case .chatRoomDetailAction(.joinChatRoomButtonTapped):
    state.chatDetailState = .init(roomId: state.chatRoomDetailState.chatRoom.id)
    return .init(value: .setIsShowPopup(true))
    
  case .chatRoomDetailAction:
    return .none
    
  case let .popularChatRoomListAction(.itemSelected(element)),
    let .chatRoomListAction(.itemSelected(element)):
    return .init(value: .annotationTapped(element))
    
  case let .popularChatRoomListAction(.getRoomListResponse(.success(response))),
    let .chatRoomListAction(.getRoomListResponse(.success(response))):
    guard let roomList = response else { return .none }
    state.chatRoomAnnotationInfos = roomList
    return .none
    
  case .popularChatRoomListAction:
    return .none
    
  case .chatRoomListAction:
    return .none
    
  case .chatDetailAction:
    return .none
    
  case let .setIsMoveToChatDetail(isMoveToChatDetail):
    state.isMoveToChatDetail = isMoveToChatDetail
    return .none
    
  case let .setIsShowPopup(isShowPopup):
    state.isShowPopup = isShowPopup
    return .none
  }
}

private let locationManagerReducer = Reducer<
  MainMapState,
  LocationManager.Action,
  MainMapEnvironment
> { state, action, _ in
  switch action {
  case .didChangeAuthorization(.denied),
      .didChangeAuthorization(.restricted):
    state.alert = .init(title: TextState("위치 서비스 설정이 허용되어야 정상적인 사용이 가능합니다."))
    return .none
    
  default:
    return .none
  }
}
