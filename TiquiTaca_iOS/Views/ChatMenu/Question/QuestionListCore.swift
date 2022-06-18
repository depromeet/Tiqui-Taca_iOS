//
//  QuestionListCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule

struct QuestionListState: Equatable {
  enum Route {
    case questionDetail
  }
  var route: Route?
  var questionList: [QuestionEntity.Response] = []
  var totalQuestionListCount: Int = 0
  var sortType: QuestionSortType = .neworder
  var sheetPresented: Bool = false
  
  var questionDetailViewState: QuestionDetailState = .init(questionId: "")
}

enum QuestionSortType: String {
  //NOTANSWERED, OLDORDER, NEWORDER, RECENT(최신2개)
  //모든 답변, 미답변, 오래된 순
  case recent = "RECENT"
  case notanswered = "NOTANSWERED"
  case oldorder = "OLDORDER"
  case neworder = "NEWORDER"
  
  var title: String {
    switch self {
    case .recent: return ""
    case .notanswered: return "미답변"
    case .oldorder: return "오래된 순"
    case .neworder: return "모든 질문"
    }
  }
}

enum QuestionListAction: Equatable {
  case selectSortType(QuestionSortType)
  case selectQuestionDetail(String)
  case sheetPresented
  case sheetDismissed
  
  case getQuestionListByType
  case getQuestionListByTypeResponse(Result<QuestionListEntity.Response?, HTTPError>)
  
  case questionDetailView(QuestionDetailAction)
  case setRoute(QuestionListState.Route?)
}

struct QuestionListEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let questionListReducer = Reducer<
  QuestionListState,
  QuestionListAction,
  QuestionListEnvironment
>.combine([
  questionDetailReducer
    .pullback(
      state: \.questionDetailViewState,
      action: /QuestionListAction.questionDetailView,
      environment:{
        QuestionDetailEnvironment.init(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
    questionListCore
])

let questionListCore = Reducer<
  QuestionListState,
  QuestionListAction,
  QuestionListEnvironment
> { state, action, environment in
  switch action {
  case .getQuestionListByType:
    let request = QuestionEntity.Request(
      filter: state.sortType.rawValue
    )
    return environment.appService.questionService
      .getQuestionList(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionListAction.getQuestionListByTypeResponse)
  case let .getQuestionListByTypeResponse(.success(response)):
    state.questionList = response?.list ?? []
    state.totalQuestionListCount = response?.totalCount ?? 0
    return .none
  case .getQuestionListByTypeResponse(.failure):
    return .none
  case let .selectSortType(type):
    state.sortType = type
    return Effect(value: .getQuestionListByType)
  case let .selectQuestionDetail(questionId):
    state.route = .questionDetail
    state.questionDetailViewState = .init(questionId: questionId)
    return .none
  case .questionDetailView(_):
    return .none
  case let .setRoute(selectedRoute):
    state.route = selectedRoute
    return .none
  case .sheetPresented:
    state.sheetPresented = true
    return .none
  case .sheetDismissed:
    state.sheetPresented = false
    return .none
  }
}
