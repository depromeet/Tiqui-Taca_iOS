//
//  ChatRoomAnnotationInfo.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

struct ChatRoomAnnotationInfo: Identifiable, Equatable {
  let id: String
  let name: String
  let category: CategoryEntity
  let radius: Int
  let userCount: Int
  let coordinate: CLLocationCoordinate2D
  
  init(
    id: String,
    name: String,
    category: CategoryEntity,
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
