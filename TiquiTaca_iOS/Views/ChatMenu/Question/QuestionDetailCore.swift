//
//  QuestionDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule

struct QuestionDetailState: Equatable {
  var question: QuestionEntity.Response?
  var likeCount: Int = 0 // API response
  var likeActivated: Bool = false
  var commentCount: Int = 0
}

enum QuestionDetailAction: Equatable {
  case backButtonAction
  case moreClickAction
  case likeClickAction
  case writeComment
  
  case likeClickResponse(Result<QuestionLikeEntity.Response?, HTTPError>)
}

struct QuestionDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let questionDetailReducer = Reducer<
  QuestionDetailState,
  QuestionDetailAction,
  QuestionDetailEnvironment
> { state, action, environment in
  switch action {
  case .likeClickAction:
    return environment.appService.questionService
      .likeQuestion(questionId: state.question?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.likeClickResponse)
  case let .likeClickResponse(.success(response)):
    state.likeActivated = response?.ilike ?? false
    state.likeCount += state.likeActivated ? 1 : 0
    return .none
  default :
    return .none
  }
}
