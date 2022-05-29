//
//  ChatMenuCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import ComposableArchitecture

struct ChatMenuState: Equatable {
  var roomName: String = "한양대"
  var participantCount: Int = 0
  var participantList: [UserEntity.Response] = []
  var questionCount: Int = 0
  var questionList: [QuestionEntity.Response] = []
  
  var questionItemViewState: QuestionItemState = .init()
}

enum ChatMenuAction: Equatable {
  case backButtonAction
  case roomExit
  case selectQuestionDetail
  case clickQuestionAll
  case questionItemView(QuestionItemAction)
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
  chatMenuReducerCore
])

let chatMenuReducerCore = Reducer<
  ChatMenuState,
  ChatMenuAction,
  ChatMenuEnvironment
> { state, action, environment in
  switch action {
  case let .questionItemView(questionItemAction):
    switch questionItemAction {
    default:
      return .none
    }
  default:
    return .none
  }
}
