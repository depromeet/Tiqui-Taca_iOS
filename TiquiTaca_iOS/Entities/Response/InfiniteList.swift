//
//  InfiniteList.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/11.
//

import Foundation

struct InfiniteList<T>: Codable, Equatable where T: Codable, T: Equatable {
  let list: [T]
  let isLast: Bool
  let lastId: String
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    list = (try? container.decode([T].self, forKey: .list)) ?? []
    isLast = (try? container.decode(Bool.self, forKey: .isLast)) ?? false
    lastId = (try? container.decode(String.self, forKey: .lastId)) ?? ""
  }
}
