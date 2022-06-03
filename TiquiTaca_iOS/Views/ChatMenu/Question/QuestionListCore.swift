//
//  QuestionListCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule

struct QuestionListState: Equatable {
  var questionList: [QuestionEntity.Response] = []
  var sortType: QuestionSortType = .neworder
  var bottomSheetPresented: Bool = false
  var enterQuestionDetail: Bool = false
  var bottomSheetPosition: TTBottomSheet.Position = .hidden
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
    case .neworder: return "모든 답변"
    }
  }
}

enum QuestionListAction: Equatable {
  case selectSortType(QuestionSortType)
  case selectQuestionDetail
  case setBottomSheetPosition(TTBottomSheet.Position)
  
  case getQuestionListByType
  case getQuestionListByTypeResponse(Result<[QuestionEntity.Response]?, HTTPError>)
}

struct QuestionListEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let questionListReducer = Reducer<
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
    state.questionList = response ?? []
    return .none
  case let .selectSortType(type):
    state.sortType = type
    state.bottomSheetPosition = .hidden
    return .none
  case .selectQuestionDetail:
    state.enterQuestionDetail = true
    return .none
  case let .setBottomSheetPosition(position):
    state.bottomSheetPosition = position
    return .none
  default:
    return .none
  }
}
