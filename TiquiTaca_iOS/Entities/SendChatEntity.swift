//
//  SendChat.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/04.
//

import Foundation
import SocketIO

struct SendChatEntity: SocketData {
  let inside: Bool
  let type: Int
  let message: String
  
  func socketRepresentation() throws -> SocketData {
    return ["inside": inside, "type": type, "message": message]
  }
}
