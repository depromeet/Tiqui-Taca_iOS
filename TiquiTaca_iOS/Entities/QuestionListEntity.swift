//
//  QuestionListEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/18.
//

import TTNetworkModule

enum QuestionListEntity {
  struct Request: Codable, JSONConvertible {
    let filter: String
  }
  
  struct Response: Codable, Equatable {
    let totalCount: Int
    let list: [QuestionEntity.Response]
    
    enum CodingKeys: String, CodingKey {
      case totalCount
      case list
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      totalCount = (try? container.decode(Int.self, forKey: .totalCount)) ?? 0
      list = try! container.decode([QuestionEntity.Response].self, forKey: .list)
    }
  }
}
