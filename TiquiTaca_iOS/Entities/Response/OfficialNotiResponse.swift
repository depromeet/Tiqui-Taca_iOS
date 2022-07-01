//
//  OfficialNotiEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/17.
//

import Foundation

struct OfficialNotiResponse: Codable, Equatable, Identifiable {
  let id: String
  let nickname: String
  let content: String
  let createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case nickname
    case content
    case createdAt
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
    content = (try? container.decode(String.self, forKey: .content)) ?? ""
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
  }
}
