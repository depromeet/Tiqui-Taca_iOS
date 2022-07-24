//
//  CategoryListResponse.swift
//  TiquiTaca_iOS
//
//  Created by MinseokKang on 2022/07/24.
//

import Foundation

struct CategoryListResponse: Codable, Equatable {
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
