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
  
  var questionCount: Int = 0
  var questionList: [QuestionEntity.Response] = []
}

enum ChatMenuAction: Equatable {
  case roomExit
}

struct ChatMenuEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatMenuReducer = Reducer<
  ChatMenuState,
  ChatMenuAction,
  ChatMenuEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
