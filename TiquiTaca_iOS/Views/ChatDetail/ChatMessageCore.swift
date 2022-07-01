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
  var receivedType: Int? = MessageType.question.rawValue
  var receivedMessage: String = "공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다"
  var createdAt: String?
  
  var sentMessage: String = "공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다공백포함 22자까지 텍스트확장입니다다다"
  var sentAt: String?
  var sentType: Int? = MessageType.question.rawValue
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
  }
}
