//
//  RoomFromCategory.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/01.
//

import Foundation
import TTNetworkModule
import CoreLocation

/// ResFindRoomDto
struct RoomFromCategoryResponse: Codable, JSONConvertible {
  let id: String
  let name: String
  let category: LocationCategory?
  let radius: Double
  let userCount: Int
  let isFavorite: Bool
  let isJoin: Bool
  let latitude: Double
  let longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case category
    case radius
    case userCount
    case isFavorite = "iFavorite"
    case isJoin = "iJoin"
    case latitude = "lat"
    case longitude = "lng"
  }
  
  init() {
    id = ""
    name = ""
    category = nil
    radius = 0
    userCount = 0
    isFavorite = false
    isJoin = false
    latitude = 0
    longitude = 0
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    name = (try? container.decode(String.self, forKey: .name)) ?? ""
    category = try? container.decode(LocationCategory.self, forKey: .category)
    radius = (try? container.decode(Double.self, forKey: .radius)) ?? 0
    userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 0
    isFavorite = (try? container.decode(Bool.self, forKey: .isFavorite)) ?? false
    isJoin = (try? container.decode(Bool.self, forKey: .isJoin)) ?? false
    latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0
    longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0
  }
}

extension RoomFromCategoryResponse: Equatable, Identifiable { }

extension RoomFromCategoryResponse {
  var geofenceRegion: CLCircularRegion {
    return .init(
      center: self.coordinate,
      radius: self.radius,
      identifier: self.id
    )
  }
  
  var coordinate: CLLocationCoordinate2D {
    return .init(latitude: self.latitude, longitude: self.longitude)
  }
  
  func distance(from currentLocation: CLLocation) -> Double {
    let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
    return currentLocation.distance(from: location)
  }
}
