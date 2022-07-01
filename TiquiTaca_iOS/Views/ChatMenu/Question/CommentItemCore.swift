//
//  CommentItemCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import Foundation

struct CommentItemState: Equatable, Identifiable {
  let id: UUID = UUID()
  var comment: CommentEntity?
}

enum CommentItemAction: Equatable {
  case moreClickAction(String, String)
  case profileSelected(UserEntity.Response?)
}

struct CommentItemEnvironment {
}

let commentItemReducer = Reducer<
  CommentItemState,
  CommentItemAction,
  CommentItemEnvironment
> { state, action, environment in
  switch action {
  case let .moreClickAction(commentId, commentUser):
    return .none
  case let .profileSelected(user):
    return .none
  }
}
