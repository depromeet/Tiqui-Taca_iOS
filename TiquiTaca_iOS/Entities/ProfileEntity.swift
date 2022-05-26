//
//  ProfileEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/11.
//

import TTNetworkModule

enum ProfileEntity {
  struct Response: Codable, Equatable {
    let id: String
    let nickname: String
    let profile: ProfileType
    let phoneNumber: String
    //    let fcmToken: String
    let appAlarm: Bool
    let chatAlarm: Bool
    let iBlockUsers: [String]
    let createdAt: String
    let lightningScore: Int
    let level: Int
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case nickname
      case profile
      case phoneNumber
      //      case fcmToken = "FCMToken"
      case appAlarm
      case chatAlarm
      case iBlockUsers
      case createdAt
      case lightningScore
      case level
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
      profile = (try? container.decode(ProfileType.self, forKey: .profile)) ?? ProfileType(type: 0)
      phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
      appAlarm = (try? container.decode(Bool.self, forKey: .appAlarm)) ?? false
      chatAlarm = (try? container.decode(Bool.self, forKey: .chatAlarm)) ?? false
      iBlockUsers = (try? container.decode([String].self, forKey: .iBlockUsers)) ?? []
      createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
      lightningScore = (try? container.decode(Int.self, forKey: .lightningScore)) ?? 0
      level = (try? container.decode(Int.self, forKey: .level)) ?? 0
    }
  }
}

struct ProfileType: Codable, Equatable {
  let type: Int
}
