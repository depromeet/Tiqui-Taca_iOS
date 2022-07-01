//
//  LetterCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import ComposableArchitecture
import TTNetworkModule

struct LetterState: Equatable {
  enum Route {
    case letterDetail
  }
  var route: Route?
  var letterDetailViewState: LetterDetailState = .init(letterRoomId: "", letterSender: .init())
  var letterSummaryList: [LetterSummaryEntity.Response] = []
}

enum LetterAction: Equatable {
  case setRoute(LetterState.Route?)
  case letterDetailView(LetterDetailAction)
  case selectLetterDetail(LetterSummaryEntity.Response)
  
  case getLetterList
  case getLetterListResponse(Result<[LetterSummaryEntity.Response]?, HTTPError>)
  case leaveLetter(String)
  case leaveLetterResponse(Result<[LetterSummaryEntity.Response]?, HTTPError>)
}

struct LetterEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let letterReducer = Reducer<
  LetterState,
  LetterAction,
  LetterEnvironment
>.combine([
  letterDetailReducer
    .pullback(
      state: \.letterDetailViewState,
      action: /LetterAction.letterDetailView,
      environment: {
        LetterDetailEnvironment.init(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  letterCore
])

private let letterCore = Reducer<
  LetterState,
  LetterAction,
  LetterEnvironment
> { state, action, environment in
  switch action {
  case .letterDetailView(_):
    return .none
  case .getLetterList:
    return environment.appService.letterService
      .getLetterList()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(LetterAction.getLetterListResponse)
  case let .getLetterListResponse(.success(response)):
    state.letterSummaryList = response ?? []
    return .none
    
  case let .leaveLetter(letterRoomId):
    return environment.appService.letterService
      .leaveLetterRoom(letterRoomId: letterRoomId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(LetterAction.leaveLetterResponse)
  case let .leaveLetterResponse(.success(response)):
    state.letterSummaryList = response ?? []
    return . none
  case .getLetterListResponse(.failure):
    return .none
  case .leaveLetterResponse(.failure):
    return .none
  case let .selectLetterDetail(letter):
    state.route = .letterDetail
    state.letterDetailViewState = .init(letterRoomId: letter.id ?? "", letterSender: letter.receiver ?? nil)
    return .none
  case let .setRoute(route):
    state.route = route
    return .none
  }
}
