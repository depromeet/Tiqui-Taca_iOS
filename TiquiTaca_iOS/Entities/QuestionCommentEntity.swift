//
//  QuestionCommentEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/04.
//

import TTNetworkModule

enum QuestionCommentEntity {
  struct Request: Codable, JSONConvertible {
    let comment: String
  }
  
  struct Response: Codable, Equatable {
    let id: String
    let comment: String
    let user: UserEntity.Response?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case comment
      case user
      case createdAt
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      comment = (try? container.decode(String.self, forKey: .comment)) ?? ""
      user = try? container.decode(UserEntity.Response.self, forKey: .user)
      createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    }
  }
}

