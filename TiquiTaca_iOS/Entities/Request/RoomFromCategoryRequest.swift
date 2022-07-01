//
//  RoomFromCategoryRequest.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/01.
//

import Foundation
import TTNetworkModule

struct RoomFromCategoryRequest: Codable, JSONConvertible {
  let latitude: Double
  let longitude: Double
  let filter: LocationCategory
  let radius: Int
  
  enum CodingKeys: String, CodingKey {
    case latitude = "lat"
    case longitude = "lng"
    case filter
    case radius
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(latitude, forKey: .latitude)
    try container.encode(longitude, forKey: .longitude)
    try container.encode(filter, forKey: .filter)
    try container.encode(radius, forKey: .radius)
  }
}
