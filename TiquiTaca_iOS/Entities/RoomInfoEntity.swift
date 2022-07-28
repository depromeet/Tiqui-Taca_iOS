//
//  RoomInfoEntity.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/10.
//

import TTNetworkModule
import CoreLocation

enum RoomInfoEntity {
  struct Request: Codable, JSONConvertible { }
  
  struct Response: Codable, Equatable, Identifiable {
    let id: String?
    let name: String?
    let category: CategoryEntity?
    let userCount: Int?
    
    let iFavorite: Bool?
    let iAlarm: Bool?
    let iJoin: Bool?
    let lat: Double?
    let lng: Double?
    
    var distance: Double?
    var radius: Double
    
    // EnteredRoom
    let lastChat: ChatLogEntity.Response?
    let notReadChatCount: Int?
    let lastChatTime: String?
    
    var viewTitle: String {
      (name ?? "") + " + \(userCount ?? 0)"
    }
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case name
      case category
      case userCount
      case notReadChatCount
      
      case distance
      case iFavorite
      case iAlarm
      case iJoin
      case lat
      case lng
      case radius
      
      case lastChat
      case lastChatTime
    }
    
    init() {
      id = nil
      name = nil
      category = nil
      userCount = nil
      
      notReadChatCount = nil
      iFavorite = true
      iAlarm = true
      iJoin = true
      lat = 0.0
      lng = 0.0
      radius = 0
      
      lastChat = nil
      lastChatTime = nil
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      name = (try? container.decode(String.self, forKey: .name)) ?? ""
      category = try? container.decode(CategoryEntity.self, forKey: .category)
      userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 1
      notReadChatCount = try? container.decode(Int?.self, forKey: .notReadChatCount)
      
      distance = try? container.decode(Double?.self, forKey: .distance)
      iFavorite = try? container.decode(Bool?.self, forKey: .iFavorite)
      iAlarm = try? container.decode(Bool?.self, forKey: .iAlarm)
      iJoin = try? container.decode(Bool?.self, forKey: .iJoin)
      lat = try? container.decode(Double?.self, forKey: .lat)
      lng = try? container.decode(Double?.self, forKey: .lng)
      radius = (try? container.decode(Double.self, forKey: .radius)) ?? 0
      
      lastChat = try? container.decode(ChatLogEntity.Response?.self, forKey: .lastChat)
      lastChatTime = try? container.decode(String?.self, forKey: .lastChatTime)
    }
  }
}

extension RoomInfoEntity.Response {
  var geofenceRegion: CLCircularRegion {
    return .init(
      center: self.coordinate,
      radius: self.radius,
      identifier: self.id ?? ""
    )
  }
  
  var coordinate: CLLocationCoordinate2D {
    return .init(latitude: self.lat ?? 0.0, longitude: self.lng ?? 0.0)
  }
}
