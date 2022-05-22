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
  var isPresentBottomSheet: Bool = false
  var chatRoomAnnotationInfos: [ChatRoomAnnotationInfo] = []
  var selectedAnnotationId: String?
  var region: MKCoordinateRegion = .init()
  var alert: AlertState<MainMapAction>?
  var isRequestingCurrentLocation: Bool = false
}

enum MainMapAction: Equatable {
  case onAppear
  case setPresentBottomSheet(Bool)
  case setSelectedAnnotationId(String?)
  case updateRegion(MKCoordinateRegion)
  case locationManager(LocationManager.Action)
  case currentLocationButtonTapped
  case dismissAlertButtonTapped
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
      state.isRequestingCurrentLocation = true
      return environment.locationManager
        .requestWhenInUseAuthorization()
        .fireAndForget()
    case .authorizedAlways, .authorizedWhenInUse:
      return environment.locationManager
        .requestLocation()
        .fireAndForget()
    default:
      return .none
    }
    
  case let .setPresentBottomSheet(isPresent):
    state.isPresentBottomSheet = isPresent
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
  }
}

private let locationManagerReducer = Reducer<
  MainMapState,
  LocationManager.Action,
  MainMapEnvironment
> { state, action, environment in
  switch action {
  case .didChangeAuthorization(.authorizedAlways),
      .didChangeAuthorization(.authorizedWhenInUse):
    if state.isRequestingCurrentLocation {
      return environment.locationManager
        .requestLocation()
        .fireAndForget()
    }
    return .none
    
  case .didChangeAuthorization(.denied),
      .didChangeAuthorization(.restricted):
    if state.isRequestingCurrentLocation {
      state.alert = .init(title: TextState("위치 서비스 설정이 허용되어야 정상적인 사용이 가능합니다."))
      state.isRequestingCurrentLocation = false
    }
    return .none
    
  case let .didUpdateLocations(locations):
    state.isRequestingCurrentLocation = false
    guard let location = locations.first else { return .none }
    state.region = MKCoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    return .none
    
  default:
    return .none
  }
}
