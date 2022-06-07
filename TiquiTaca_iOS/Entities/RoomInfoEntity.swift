//
//  RoomInfoEntity.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/10.
//

import TTNetworkModule

enum RoomInfoEntity {
  struct Request: Codable, JSONConvertible { }
  
  struct Response: Codable, Equatable, Identifiable {
    let id: String?
    let name: String?
    let category: LocationCategory?
    let userCount: Int?
    
    let notReadChatCount: Int?
    let lastChatMessage: String?
    let lastChatTime: String?
    
    var distance: Double?
    
    var viewTitle: String {
      (name ?? "") + " \(userCount ?? 0)"
    }
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case name
      case category
      case userCount
      case notReadChatCount
      case lastChatMessage
      case lastChatTime
      case distance
    }
    
    init() {
      id = nil
      name = nil
      category = nil
      userCount = nil
      
      notReadChatCount = nil
      lastChatMessage = nil
      lastChatTime = nil
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      name = (try? container.decode(String.self, forKey: .name)) ?? ""
      category = try? container.decode(LocationCategory.self, forKey: .category)
      userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 1
      notReadChatCount = try? container.decode(Int?.self, forKey: .notReadChatCount)
      lastChatMessage = try? container.decode(String?.self, forKey: .lastChatMessage)
      lastChatTime = try? container.decode(String?.self, forKey: .lastChatTime)
      distance = try? container.decode(Double?.self, forKey: .distance)
    }
  }
}
