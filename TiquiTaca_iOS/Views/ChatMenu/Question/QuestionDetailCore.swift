//
//  QuestionDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule

struct QuestionDetailState: Equatable {
  var questionId: String
  var question: QuestionEntity.Response?
  var likesCount: Int = 0 // API response
  var likeActivated: Bool = false
  var commentCount: Int = 0
}

enum QuestionDetailAction: Equatable {
  case moreClickAction
  case likeClickAction
  case writeComment
  
  case getQuestionDetail
  case getQuestionDetailResponse(Result<QuestionEntity.Response?, HTTPError>)
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
  case .getQuestionDetail:
    return environment.appService.questionService
      .getQuestionDetail(questionId: state.questionId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.getQuestionDetailResponse)
  case let .getQuestionDetailResponse(.success(response)):
    state.question = response
    return .none
  case .getQuestionDetailResponse(.failure):
    return .none
    
  case .likeClickAction:
    return environment.appService.questionService
      .likeQuestion(questionId: state.question?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.likeClickResponse)
  case let .likeClickResponse(.success(response)):
    state.likeActivated = response?.ilike ?? false
    state.likesCount += state.likeActivated ? 1 : 0
    return .none
  case .likeClickResponse(.failure):
    return .none
    
  case .moreClickAction:
    return .none
  case .writeComment:
    return .none
  }
}
