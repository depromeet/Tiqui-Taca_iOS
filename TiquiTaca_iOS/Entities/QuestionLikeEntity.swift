//
//  QuestionLikeEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/02.
//

import TTNetworkModule

enum QuestionLikeEntity {
  struct Response: Codable, Equatable, JSONConvertible {
    let ilike: Bool
  }
}

