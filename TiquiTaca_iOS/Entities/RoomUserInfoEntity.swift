//
//  RoomUserInfoEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/02.
//

import TTNetworkModule

enum RoomUserInfoEntity {
  struct Request: Codable, Equatable { }
  
  struct Response: Codable, Equatable {
    let userList: [UserEntity.Response]?
    let userCount: Int?
    
    enum CodingKeys: String, CodingKey {
      case userList
      case userCount
    }
    
    init() {
      userList = nil
      userCount = nil
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      userList = (try? container.decode([UserEntity.Response].self, forKey: .userList))
      userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 0
    }
  }
}
