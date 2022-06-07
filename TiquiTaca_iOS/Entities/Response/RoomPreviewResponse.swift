//
//  RoomPreviewResponse.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/01.
//

import Foundation

/// ResShortCutRoomDto
struct RoomPreviewResponse: Codable, RoomDefaultInfo {
  let id: String
  let name: String
  let category: LocationCategory
  let userCount: Int
  let latitude: Double
  let longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case category
    case userCount
    case latitude = "lat"
    case longitude = "lng"
  }
  
  init() {
    id = ""
    name = ""
    category = .all
    userCount = 0
    latitude = 0
    longitude = 0
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    category = (try? container.decode(LocationCategory.self, forKey: .category)) ?? .all
    userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 0
    latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0
    longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0
  }
}

extension RoomPreviewResponse: Equatable, Identifiable { }
