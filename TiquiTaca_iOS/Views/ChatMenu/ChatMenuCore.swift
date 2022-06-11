//
//  ChatMenuCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import ComposableArchitecture
import TTNetworkModule

struct ChatMenuState: Equatable {
  enum Route {
    case questionDetail
    case questionList
  }
  var route: Route?
  var roomInfo: RoomInfoEntity.Response?
  var roomUserList: [UserEntity.Response] = []
  var questionList: [QuestionEntity.Response] = []
  var selectedQuestionId: String?
  
  var questionDetailViewState: QuestionDetailState = .init(questionId: "")
  var questionListViewState: QuestionListState = .init()
  
  
  var popupPresented: Bool = false
  var isFavorite = false
  var isExistRoom: Bool = true
}

enum ChatMenuAction: Equatable {
  case setRoute(ChatMenuState.Route?)
  case roomExit
  
  case roomFavoriteSelect
  case roomFavoriteResponse(Result<RoomLikeEntity.Response?, HTTPError>)
  
  case questionSelected(String)
  case questionListButtonClicked
  case questionDetailView(QuestionDetailAction)
  case questionListView(QuestionListAction)
  
  case getRoomInfo
  case getRoomInfoResponse(Result<RoomInfoEntity.Response?, HTTPError>)
  case getRoomInfoRequestSuccess
  
  case getRoomUserListInfo
  case getRoomUserListResponse(Result<RoomUserInfoEntity.Response?, HTTPError>)
  
  case getQuestionList
  case getQuestionListResponse(Result<[QuestionEntity.Response]?, HTTPError>)
  case roomExitReponse(Result<DefaultResponse?, HTTPError>)
  
  case presentPopup
  case dismissPopup
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
  questionDetailReducer
    .pullback(
      state: \.questionDetailViewState,
      action: /ChatMenuAction.questionDetailView,
      environment: {
        QuestionDetailEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  questionListReducer
    .pullback(
      state: \.questionListViewState,
      action: /ChatMenuAction.questionListView,
      environment: {
        QuestionListEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
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
    // MARK: 방 정보 API (추후 제거)
  case .getRoomInfo:
    return environment.appService.roomService
      .getMyRoomInfo()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getRoomInfoResponse)
  case let .getRoomInfoResponse(.success(response)):
    state.roomInfo = response
    return Effect(value: .getRoomInfoRequestSuccess)
  case .getRoomInfoRequestSuccess:
    return .none
  case .getRoomInfoResponse(.failure):
    return .none
    
    // MARK: 방 즐겨찾기 API
  case .roomFavoriteSelect:
    return environment.appService.roomService
      .registLikeRoom(roomId: state.roomInfo?.id ?? "")
      .throttle(for: 1, scheduler: environment.mainQueue, latest: true)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.roomFavoriteResponse)
  case let .roomFavoriteResponse(.success(res)):
    guard let favorite = res?.iFavoritRoom, state.isFavorite != favorite else { return .none }
    state.isFavorite = favorite
    return .none
  case .roomFavoriteResponse(.failure):
    return .none
    // MARK: 채팅방 참여자 API
  case .getRoomUserListInfo:
    return environment.appService.roomService
      .getRoomUserList(roomId: state.roomInfo?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getRoomUserListResponse)
  case let .getRoomUserListResponse(.success(response)):
    state.roomUserList = response?.userList ?? []
    return .none
  case .getRoomUserListResponse(.failure):
    return .none
    
    // MARK: 질문 리스트 API
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
    
    // MARK: 방 나가기 API
  case .roomExit:
    return environment.appService.roomService
      .exitRoom(roomId: state.roomInfo?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.roomExitReponse)
  case let .roomExitReponse(.success(response)):
    state.isExistRoom = false
    return .none
  case .roomExitReponse(.failure):
    return .none
    
  case let .questionDetailView(questionDetailAction):
    return .none
  case let .questionListView(questionListAction):
    return .none
    
  case let .setRoute(selectedRoute):
    if selectedRoute == .questionDetail {
      state.questionDetailViewState = .init(questionId: state.selectedQuestionId ?? "")
    }
    state.route = selectedRoute
    return .none
    
  case let .questionSelected(questionId):
    state.selectedQuestionId = questionId
    state.questionDetailViewState = .init(questionId: state.selectedQuestionId ?? "")
    state.route = .questionDetail
    return .none
  case .questionListButtonClicked:
    state.route = .questionList
    return .none
    
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  }
}
