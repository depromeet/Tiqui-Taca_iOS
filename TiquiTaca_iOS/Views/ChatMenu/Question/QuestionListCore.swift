//
//  QuestionListCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture

struct QuestionListState: Equatable {
  var questionList: [QuestionEntity.Response] = []
  var sortType: QuestionSortType = .oldorder
  var bottomSheetPresented: Bool = false
  var enterQuestionDetail: Bool = false
}

enum QuestionSortType {
  //NOTANSWERED, OLDORDER, NEWORDER, RECENT(서버)
  //모든 답변, 미답변, 오래된 순(기획)
  case recent
  case notanswered
  case oldorder
}

enum QuestionListAction: Equatable {
  case backButtonAction
  case selectSortType
  case selectQuestionDetail
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
  case .selectSortType:
    state.bottomSheetPresented = true
    return .none
  case .selectQuestionDetail:
    state.enterQuestionDetail = true
    return .none
  default:
    return .none
  }
}
