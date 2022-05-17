//
//  BlockUserEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/13.
//

import Foundation

enum BlockUserEntity: Equatable {
  struct Response: Codable, Equatable {
    let id: String
    let nickname: String
    let profile: ProfileType
    let level: Int
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case nickname
      case profile
      case level
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
      profile = (try? container.decode(ProfileType.self, forKey: .profile)) ?? ProfileType(type: 0)
      level = (try? container.decode(Int.self, forKey: .level)) ?? 0
    }
  }
  
  struct ProfileType: Codable, Equatable {
    let type: Int
  }
}
