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
    case quetionList
    case questionDetail
  }
  var route: Route?
  var roomInfo: RoomInfoEntity.Response?
  var roomUserList: [UserEntity.Response] = []
  var questionList: [QuestionEntity.Response] = []
  var unreadChatCount: Int? = 0 //값 받아와야함
  
  var questionItemViewState: QuestionItemState = .init()
  var questionListViewState: QuestionListState = .init()
  
  var popupPresented: Bool = false
}

enum ChatMenuAction: Equatable {
  case setRoute(ChatMenuState.Route)
  case roomExit
  case selectQuestionDetail
  case clickQuestionAll
  case questionItemView(QuestionItemAction)
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
  questionListReducer
    .pullback(
      state: \.questionListViewState,
      action: /ChatMenuAction.questionListView,
      environment: { _ in
        QuestionListEnvironment(
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
    return Effect(value: .getRoomInfoRequestSuccess)
  case .getRoomInfoRequestSuccess:
    return .none
    
  case .getRoomUserListInfo:
    return environment.appService.roomService
      .getRoomUserList(roomId: state.roomInfo?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChatMenuAction.getRoomUserListResponse)
  case let .getRoomUserListResponse(.success(response)):
    state.roomUserList = response?.userList ?? []
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
    return .none
  case let .questionListView(questionListAction):
    return .none
  case let .setRoute(selectedRoute):
//    if selectedRoute == .questionDetail {
//      state.questionItemViewState = .init(
//        id: <#T##String#>,
//        user: <#T##UserEntity.Response?#>,
//        content: <#T##String#>,
//        commentList: <#T##[CommentEntity]#>,
//        createdAt: <#T##Date#>,
//        likesCount: <#T##Int#>,
//        commentsCount: <#T##Int#>,
//        ilike: <#T##Bool#>
//      )
//    }
    state.route = selectedRoute
    return .none
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  default:
    return .none
  }
}
