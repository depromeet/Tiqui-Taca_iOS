//
//  ChatRoomInfo.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import MapKit

//{
//  "_id": "string",
//  "name": "홍익대학교",
//  "category": "UNIVERCITY",
//  "radius": 2000,
//  "userCount": 0,
//  "iFavorite": true,
//  "iJoin": true,
//  "lat": 0,
//  "lng": 0
//}

struct ChatRoomAnnotationInfo: Equatable, Hashable {
  let id: String
  let name: String
  let category: String
  let radius: Int
  let userCount: Int
  let coordinate: CLLocationCoordinate2D
  
//  init(
//    id: String,
//    name: String,
//    category: String,
//    radius: Int,
//    userCount: Int,
//    coordinate: CLLocationCoordinate2D
//  ) {
//    self.id = id
//  }
}

extension ChatRoomAnnotationInfo {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.category == rhs.category
    && lhs.radius == rhs.radius
    && lhs.userCount == rhs.userCount
    && lhs.coordinate.latitude == rhs.coordinate.latitude
    && lhs.coordinate.longitude == rhs.coordinate.longitude
  }
  
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
