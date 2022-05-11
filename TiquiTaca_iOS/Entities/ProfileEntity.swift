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
    //    let profile: ProfileType
    //    let fcmToken: String
    let appAlarm: Bool
    let chatAlarm: Bool
    let iBlockUsers: [String]
    let createdAt: Date?
    let lightningScore: Int
    let level: Int
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case nickname
      //      case profile
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
      appAlarm = (try? container.decode(Bool.self, forKey: .appAlarm)) ?? false
      chatAlarm = (try? container.decode(Bool.self, forKey: .chatAlarm)) ?? false
      iBlockUsers = (try? container.decode([String].self, forKey: .iBlockUsers)) ?? []
      createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
      lightningScore = (try? container.decode(Int.self, forKey: .lightningScore)) ?? 0
      level = (try? container.decode(Int.self, forKey: .level)) ?? 0
    }
  }
}

/*
 "_id": "6276018e68fbd9188ab47012",
 "nickname": "송하갱",
 "profile": {
 "type": 3
 },
 "FCMToken": "string",
 "appAlarm": true,
 "chatAlarm": true,
 "iBlockUsers": [],
 "createdAt": "2022-05-07T14:20:14+09:00",
 "lightningScore": 39,
 "level": 2
 */
