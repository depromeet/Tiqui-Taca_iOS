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
  static let koreaLocation: CLLocationCoordinate2D = .init(latitude: 37.541, longitude: 126.986)
  
  typealias MapUserTrackingModeType = MapUserTrackingMode // Map 네이밍 중복 문제
  
  var bottomSheetPosition: TTBottomSheet.Position = .hidden
  var bottomSheetType: MainMapBottomSheetType = .popularChatRoomList
  var chatRoomAnnotationInfos: [RoomFromCategoryResponse] = []
  var region: MKCoordinateRegion = .init(center: koreaLocation, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
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
  
  case showLocationAlert
  case moveToSetting
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
    // 첫 위치 권한 설정, onLoad, 현위치 버튼
    guard environment.locationManager.locationServicesEnabled() else {
      return .init(value: .showLocationAlert)
    }
    
    switch environment.locationManager.authorizationStatus() {
    case .restricted, .denied:
      return .init(value: .showLocationAlert)
    case .notDetermined:
      return environment.locationManager
        .requestWhenInUseAuthorization()
        .fireAndForget()
    case .authorizedAlways, .authorizedWhenInUse:
      guard let location = environment.locationManager.location() else { return .none }
      // 내 위치로 이동
      state.region = MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )
      
      // 첫 위치 권한 설정 및 onLoad 때문에 존재
      state.chatRoomListState.currentLocation = location.rawValue
      state.popularChatRoomListState.currentLocation = location.rawValue
      state.chatRoomDetailState.currentLocation = location.rawValue
      
      return .merge([
        .init(value: .setUserTrackingMode(.follow)),
        .init(value: .popularChatRoomListAction(.requestChatRoomList)),
        environment.locationManager
          .requestLocation()
          .fireAndForget()
      ])
    default:
      return .none
    }
    
    /*
     - chatRoomDetail: hidden, quarter
     - chatRoomList: hidden, middle, top
     - popularChatRoomList: hidden, middle
     */
  case let .setBottomSheetPosition(position):
    switch state.bottomSheetType {
    case .chatRoomDetail:
      if position == .middle || position == .top {
        return .none
      }
    case .chatRoomList:
      if position == .quarter {
        return .none
      }
    case .popularChatRoomList:
      if position == .quarter || position == .top {
        return .none
      }
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
      .init(value: .setBottomSheetPosition(.quarter))
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
        .init(value: .setBottomSheetPosition(.hidden)),
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
    
  case .showLocationAlert:
    state.alert = .init(
      title: TextState("위치서비스를 사용할 수 없습니다.\n기기의 \"설정 > 티키타카 > 위치\"에서 위치 서비스를 켜주세요."),
      buttons: [
        .cancel(.init("취소")),
        .default(.init("설정으로 이동"), action: .send(.moveToSetting))
      ]
    )
    return .none
    
  case .moveToSetting:
    guard let openSettingsURL = URL(string: UIApplication.openSettingsURLString) else {
      return .none
    }
    UIApplication.shared.open(openSettingsURL, options: [:], completionHandler: nil)
    return .none
    
    // MARK: - LocationManager
  case let .locationManager(.didUpdateLocations(locations)):
    guard let location = locations.first else { return .none }
    
    state.chatRoomListState.currentLocation = location.rawValue
    state.popularChatRoomListState.currentLocation = location.rawValue
    state.chatRoomDetailState.currentLocation = location.rawValue
    
    return .init(value: .chatRoomDetailAction(.checkCurrentLocationWithinRadius))
  case .locationManager(.didChangeAuthorization(.authorizedAlways)),
      .locationManager(.didChangeAuthorization(.authorizedWhenInUse)):
    return .init(value: .currentLocationButtonTapped)
  case .locationManager(.didChangeAuthorization(.denied)),
      .locationManager(.didChangeAuthorization(.restricted)):
    return .init(value: .showLocationAlert)
  case .locationManager:
    return .none
  }
}
