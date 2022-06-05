//
//  ChatRoom.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import RealmSwift

class ChatRoom: Object {
  @objc dynamic var id: String?
  @objc dynamic var name: String?
  @objc dynamic var category: String?
  @objc dynamic var userCount: Int = 1
}
