//
//  UserEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/30.
//

import TTNetworkModule

enum UserEntity {
  struct Response: Codable, Equatable {
    let status: String
    let fcmToken: String
    
    let id: String
    let nickname: String
    let phoneNumber: String
    let createdAt: Date?
    let updatedAt: Date?
    //  let profile: ?
    //  let favoriteRoomList: ?
    
    enum CodingKeys: String, CodingKey {
      case status
      case fcmToken = "FCMToken"
      case id = "_id"
      case nickname
      case phoneNumber
      case createdAt
      case updatedAt
      //    case profile
      //    case favoriteRoomList
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = (try? container.decode(String.self, forKey: .status)) ?? ""
      fcmToken = (try? container.decode(String.self, forKey: .fcmToken)) ?? ""
      
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
      phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
      createdAt = try? container.decode(Date.self, forKey: .createdAt)
      updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
      //    profile = try container.decode(.self, forKey: .profile)
      //    favoriteRoomList = try container.decode(.self, forKey: .favoriteRoomList)
    }
  }
}
