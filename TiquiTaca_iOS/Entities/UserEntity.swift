//
//  UserEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/11.
//

import TTNetworkModule

enum UserStatus: String, Codable {
  case normal
  case forbidden
  case signOut
}

enum UserEntity {
  struct Response: Codable, Equatable, Identifiable {
    let id: String
    let nickname: String
    let profile: ProfileImage
    let phoneNumber: String
    let fcmToken: String
    let appAlarm: Bool
    let chatAlarm: Bool
    let iBlockUsers: [String]
    let createdAt: String
    let lightningScore: Int
    let level: Int
    
    // 다른 사람 프로필
    let status: UserStatus
    let iBlock: Bool
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case nickname
      case profile
      case phoneNumber
      case fcmToken = "FCMToken"
      case appAlarm
      case chatAlarm
      case iBlockUsers
      case createdAt
      case lightningScore
      case level
      case status
      case iBlock
    }
    
    init() {
      id = ""
      nickname = ""
      profile = ProfileImage.init()
      phoneNumber = ""
      fcmToken = ""
      appAlarm = false
      chatAlarm = false
      iBlockUsers = []
      createdAt = ""
      lightningScore = 0
      level = 0
      status = .normal
      iBlock = false
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
      profile = (try? container.decode(ProfileImage.self, forKey: .profile)) ?? ProfileImage(type: 0)
      phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
      appAlarm = (try? container.decode(Bool.self, forKey: .appAlarm)) ?? false
      fcmToken = (try? container.decode(String.self, forKey: .fcmToken)) ?? ""
      chatAlarm = (try? container.decode(Bool.self, forKey: .chatAlarm)) ?? false
      iBlockUsers = (try? container.decode([String].self, forKey: .iBlockUsers)) ?? []
      createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
      lightningScore = (try? container.decode(Int.self, forKey: .lightningScore)) ?? 0
      level = (try? container.decode(Int.self, forKey: .level)) ?? 0
      
      status = (try? container.decode(UserStatus.self, forKey: .status)) ?? .normal
      iBlock = (try? container.decode(Bool.self, forKey: .iBlock)) ?? false
    }
  }
}

struct ProfileType: Codable, Equatable {
  let type: Int
}

enum ReportEntity {
  struct Response: Codable, Equatable, JSONConvertible {
    let reportSuccess: Bool
  }
}

extension UserEntity.Response {
  var canUseFeature: Bool {
    status == .normal && iBlock == false
  }
}
