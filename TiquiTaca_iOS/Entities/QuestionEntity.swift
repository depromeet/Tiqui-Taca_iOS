//
//  QuestionEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import TTNetworkModule

enum QuestionEntity {
  struct Request: Codable, JSONConvertible {
    let filter: String
  }
  
  struct Response: Codable, Equatable, Identifiable {
    let id: String
    let user: UserEntity.Response?
    let content: String
    let commentList: [CommentEntity]
    let createdAt: Date
    let likesCount: Int
    let commentsCount: Int
    let ilike: Bool
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case user
      case content
      case commentList
      case createdAt
      case likesCount
      case commentsCount
      case ilike
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      user = try? container.decode(UserEntity.Response.self, forKey: .user)
      content = (try? container.decode(String.self, forKey: .content)) ?? ""
      commentList = (try? container.decode([CommentEntity].self, forKey: .commentList)) ?? []
      createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
      likesCount = (try? container.decode(Int.self, forKey: .likesCount)) ?? 0
      commentsCount = (try? container.decode(Int.self, forKey: .commentsCount)) ?? 0
      ilike = (try? container.decode(Bool.self, forKey: .ilike)) ?? false
    }
  }
}
