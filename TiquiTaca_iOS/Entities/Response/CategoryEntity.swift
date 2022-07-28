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
  
  init(id: String, name: String, imageUrl: URL?) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    imageUrl = try? container.decode(URL.self, forKey: .imageUrl)
  }
}

extension CategoryEntity {
  // 전체 타입
  static var ALL: Self {
    return .init(id: "ALL", name: "전체", imageUrl: nil)
  }
  
  // 즐겨찾기 타입
  static var FAVORITE: Self {
    return .init(id: "FAVORITE", name: "즐겨찾기", imageUrl: nil)
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
