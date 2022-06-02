//
//  CommentItemCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture

struct CommentItemState: Equatable {
  var comment: CommentEntity?
}

enum CommentItemAction: Equatable {
  case moreClickAction
}

struct CommentItemEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let commentItemReducer = Reducer<
  CommentItemState,
  CommentItemAction,
  CommentItemEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
