//
//  QuestionInputMessageCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/04.
//

import ComposableArchitecture

struct QuestionInputMessageState: Equatable {
  var inputMessage: String = ""
}

enum QuestionInputMessageAction: Equatable {
  case messageTyping(String)
  case sendMessage
}

struct QuestionInputMessageEnvironment: Equatable {
}

let questionInputMessageReducer = Reducer<
  QuestionInputMessageState,
  QuestionInputMessageAction,
  QuestionInputMessageEnvironment
> { state, action, environment in
  switch action {
  case let .messageTyping(message):
    state.inputMessage = message
    return .none
  case .sendMessage:
    return .none
  }
}
