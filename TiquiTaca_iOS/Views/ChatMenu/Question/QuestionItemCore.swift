//
//  QuestionItemCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture

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
    state.ilike = true
    //API call
    return .none
  default:
    return .none
  }
}
