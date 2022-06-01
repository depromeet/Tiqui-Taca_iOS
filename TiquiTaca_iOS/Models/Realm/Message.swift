//
//  Message.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import RealmSwift

class Message: Object {
  @objc dynamic var roomId: String = ""
  @objc dynamic var senderNickname: String?
  @objc dynamic var senderProfileImage: String?
  @objc dynamic var senderInsideFlag: String?
  
  @objc dynamic var receivedMessage: String?
  @objc dynamic var receivedAt: Date?
  @objc dynamic var sentMessage: String?
  @objc dynamic var sentAt: Date?
  
  var messageType: MessageType?
}

enum MessageType: Int {
  case text = 0
  case question = 1
}
