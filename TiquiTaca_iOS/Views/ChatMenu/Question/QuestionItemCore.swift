//
//  QuestionItemCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule

struct QuestionItemState: Equatable {
  var id: String = ""
  var user: UserEntity.Response?
  var content: String = ""
  var commentList: [CommentEntity] = []
  var createdAt: Date = Date()
  var likesCount: Int = 0
  var commentsCount: Int = 0
  var ilike: Bool = false
}

enum QuestionItemAction: Equatable {
  case likeClickAction
  case likeClickResponse(Result<QuestionLikeEntity.Response?, HTTPError>)
}

struct QuestionItemEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let questionItemReducer = Reducer<
  QuestionItemState,
  QuestionItemAction,
  QuestionItemEnvironment
> { state, action, environment in
  switch action {
  case .likeClickAction:
    return environment.appService.questionService
      .likeQuestion(questionId: state.id)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionItemAction.likeClickResponse)
  case let .likeClickResponse(.success(response)):
    state.ilike = response?.ilike ?? false
    return .none
  default:
    return .none
  }
}
