//
//  ChatMenuCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import ComposableArchitecture
import TTNetworkModule

struct ChatMenuState: Equatable {
  var roomInfo: RoomInfoEntity.Response?
  var roomUserCount: Int = 0
  var roomUserList: [UserEntity.Response] = []
  var questionCount: Int = 0
  var questionList: [QuestionEntity.Response] = []
  
  var questionItemViewState: QuestionItemState = .init()
}

enum ChatMenuAction: Equatable {
  case backButtonAction
  case roomExit
  case selectQuestionDetail
  case clickQuestionAll
  case questionItemView(QuestionItemAction)
  
  case getRoomInfo
  case getRoomInfoResponse(Result<RoomInfoEntity.Response?, HTTPError>)
  
  case getRoomUserListInfo
  case getRoomUserListResponse(Result<RoomUserInfoEntity.Response?, HTTPError>)
  
  case getQuestionList
  case getQuestionListResponse(Result<[QuestionEntity.Response]?, HTTPError>)
  case roomExitReponse(Result<DefaultResponse?, HTTPError>)
}

struct ChatMenuEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatMenuReducer = Reducer<
  ChatMenuState,
  ChatMenuAction,
  ChatMenuEnvironment
>.combine([
  questionItemReducer
    .pullback(
      state: \.questionItemViewState,
      action: /ChatMenuAction.questionItemView,
      environment: { _ in
        QuestionItemEnvironment(
          appService: AppService(),
          mainQueue: .main
        )
      }
    ),
  chatMenuReducerCore
])

let chatMenuReducerCore = Reducer<
  ChatMenuState,
  ChatMenuAction,
  ChatMenuEnvironment
> { state, action, environment in
  switch action {
  case .getRoomInfo:
    return environment.appService.roomService
      .getMyRoomInfo()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getRoomInfoResponse)
  case let .getRoomInfoResponse(.success(response)):
    state.roomInfo = response
    return .none
    
  case .getRoomUserListInfo:
    return environment.appService.roomService
      .getRoomUserList(roomId: state.roomInfo?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getRoomUserListResponse)
  case let .getRoomUserListResponse(.success(response)):
    state.roomUserList = response?.userList ?? []
    state.roomUserCount = response?.userCount ?? 0
    return .none
  case .getQuestionList:
    let request = QuestionEntity.Request(
      filter: QuestionSortType.recent.rawValue
    )
    return environment.appService.questionService
      .getQuestionList(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getQuestionListResponse)
  case let .getQuestionListResponse(.success(response)):
    state.questionList = response ?? []
    return .none
  case .getQuestionListResponse(.failure):
    return .none
    
  case .roomExit:
    return environment.appService.roomService
      .exitRoom(roomId: state.roomInfo?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.roomExitReponse)
  case let .roomExitReponse(.success(response)):
    #warning("채팅 탭으로 가는 액션 필요")
    return .none
    
  case let .questionItemView(questionItemAction):
    switch questionItemAction {
    default:
      return .none
    }
  default:
    return .none
  }
}
