//
//  ChatRoomAnnotationInfo.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

struct ChatRoomAnnotationInfo: Identifiable, Equatable, Hashable {
  let id: String
  let name: String
  let category: LocationCategory
  let radius: Int
  let userCount: Int
  let coordinate: CLLocationCoordinate2D
  
  init(
    id: String,
    name: String,
    category: LocationCategory,
    radius: Int,
    userCount: Int,
    latitude: Double,
    longitude: Double
  ) {
    self.id = id
    self.name = name
    self.category = category
    self.radius = radius
    self.userCount = userCount
    coordinate = .init(latitude: latitude, longitude: longitude)
  }
}

extension ChatRoomAnnotationInfo {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(category)
    hasher.combine(radius)
    hasher.combine(userCount)
    hasher.combine(coordinate.latitude)
    hasher.combine(coordinate.longitude)
  }
}
