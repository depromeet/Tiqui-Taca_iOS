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
}

enum MainMapAction: Equatable {
  case onAppear
  case setPresentBottomSheet(Bool)
  case setSelectedAnnotationId(String?)
  case updateRegion(MKCoordinateRegion)
}

struct MainMapEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
//  var locationManager: LocationManager
}

let mainMapReducer = Reducer<
  MainMapState,
  MainMapAction,
  MainMapEnvironment
> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  case let .setPresentBottomSheet(isPresent):
    state.isPresentBottomSheet = isPresent
    return .none
  case let .setSelectedAnnotationId(id):
    state.selectedAnnotationId = id
    return .none
  case let .updateRegion(region):
    state.region = region
    return .none
  }
}
