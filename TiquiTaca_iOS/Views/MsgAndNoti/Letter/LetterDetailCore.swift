//
//  LetterDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by hakyung on 2022/06/10.
//

import ComposableArchitecture
import TTNetworkModule

struct LetterDetailState: Equatable {
  enum Route {
    case sendLetter
  }
  var route: Route?
  var letterRoomId: String
  var letterSender: UserEntity.Response?
  var letterSendViewState: LetterSendState = .init()
  var loginUserId: String = ""
  
  var letterList: [LetterEntity.Response] = []
}

enum LetterDetailAction: Equatable {
  case onAppear
  case setRoute(LetterDetailState.Route?)
  case letterSendView(LetterSendAction)
  
  case getLetterList
  case getLetterListResponse(Result<[LetterEntity.Response]?, HTTPError>)
}

struct LetterDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let letterDetailReducer = Reducer<
  LetterDetailState,
  LetterDetailAction,
  LetterDetailEnvironment
>.combine([
  letterSendReducer
    .pullback(
      state: \.letterSendViewState,
      action: /LetterDetailAction.letterSendView,
      environment: {
        LetterSendEnvironment.init(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  letterDetailCore
])

private let letterDetailCore = Reducer<
  LetterDetailState,
  LetterDetailAction,
  LetterDetailEnvironment
> { state, action, environment in
  switch action {
  case .letterSendView(_):
    return .none
  case .onAppear:
    state.loginUserId = environment.appService.userService.myProfile?.id ?? ""
    state.letterSendViewState = .init(sendingUser: state.letterSender)
    
    return Effect(value: .getLetterList)
  case .getLetterList:
    return environment.appService.letterService
      .getLetterRoomInfo(letterRoomId: state.letterRoomId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(LetterDetailAction.getLetterListResponse)
  case let .getLetterListResponse(.success(response)):
    state.letterList = response ?? []

//    state.letterList.forEach {
//      if $0.sender?.id == environment.appService.userService.myProfile?.id {
//        $0.sender?.nickname = "나\()"
//      }
//    }
    
    return .none
  case .getLetterListResponse(.failure):
    return .none
  case let .setRoute(route):
    state.route = route
    return .none
  }
}
