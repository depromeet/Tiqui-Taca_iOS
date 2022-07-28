//
//  CategoryEntity.swift
//  TiquiTaca_iOS
//
//  Created by MinseokKang on 2022/07/24.
//

import Foundation

struct CategoryEntity: Codable, Equatable, Identifiable {
  var id: String
  var name: String
  var imageUrl: URL?
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    imageUrl = try? container.decode(URL.self, forKey: .imageUrl)
  }
}

extension CategoryEntity {
  /// 전체 타입 여부
  var isAllType: Bool {
    return id == "ALL"
  }
  
  /// 즐겨찾기 타입 여부
  var isFavoriteType: Bool {
    return id == "FAVORITE"
  }
}
