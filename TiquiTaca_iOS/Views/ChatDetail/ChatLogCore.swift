//
//  ChatLogCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import ComposableArchitecture

struct ChatLogState: Equatable {
  var roomName: String = "한양대"
  var roomAlarm: Bool = false
  var participantCount: Int = 0
  var chatLogList: [ChatLogEntity.Response]
}

enum ChatLogAction: Equatable {
  case chatMenuClicked
  case roomAlamOff
}

struct ChatLogEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let chatLogReducer = Reducer<
  ChatLogState,
  ChatLogAction,
  ChatLogEnvironment
> { state, action, environment in
  switch action {
  case .roomAlamOff:
    state.roomAlarm.toggle()
    return .none
  default:
    return .none
  }
  
}
