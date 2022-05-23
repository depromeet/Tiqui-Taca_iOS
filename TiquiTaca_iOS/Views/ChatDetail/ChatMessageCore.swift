//
//  ChatMessageCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/23.
//

import ComposableArchitecture

struct ChatMessageState: Equatable {
  var id: String = "하갱"
  var profileImage: String = "defaultProfile"
  var inside: Bool = true
  var type: Int = 2
  var receivedMessage: String = "공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다"
  var createdAt: Date?
  
  var sentMessage: String = "보낸 메시지"
  var sentAt: Date?
}

enum ChatMessageAction: Equatable {
}

struct ChatMessageEnvironment {
}

let chatMessageReducer = Reducer<
  ChatMessageState,
  ChatMessageAction,
  ChatMessageEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
