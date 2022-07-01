//
//  LetterEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/09.
//

import TTNetworkModule

enum LetterEntity {
  struct Request: Codable, JSONConvertible {
    let message: String
  }
  
  struct Response: Codable, Equatable, Identifiable {
    let sender: UserEntity.Response?
    let id: String?
    let createdAt: String?
    let message: String?
    let iWatch: Bool?
    
    enum CodingKeys: String, CodingKey {
      case sender
      case id = "_id"
      case createdAt
      case message
      case iWatch
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      sender = try? container.decode(UserEntity.Response.self, forKey: .sender)
      id = try? container.decode(String.self, forKey: .id)
      createdAt = try? container.decode(String.self, forKey: .createdAt)
      message = try? container.decode(String.self, forKey: .message)
      iWatch = try? container.decode(Bool.self, forKey: .iWatch)
    }
  }
}
