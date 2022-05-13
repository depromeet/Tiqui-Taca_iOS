//
//  UserCreationEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/13.
//

import TTNetworkModule

enum UserCreationEntity {
  struct Request: Codable, JSONConvertible {
    let phoneNumber: String
    let nickname: String
    let profileImageType: Int
    let isAgreed: Bool
    let FCMToken: String
    
    enum CodingKeys: String, CodingKey {
      case phoneNumber
      case nickname
      case profileImageType = "profile"
      case isAgreed
      case FCMToken
    }
    
    enum ProfileCodingKeys: String, CodingKey {
      case type
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(phoneNumber, forKey: .phoneNumber)
      try container.encode(nickname, forKey: .nickname)
      try container.encode(isAgreed, forKey: .isAgreed)
      try container.encode(FCMToken, forKey: .FCMToken)
      
      var profileContainer = container.nestedContainer(keyedBy: ProfileCodingKeys.self, forKey: .profileImageType)
      try profileContainer.encode(profileImageType, forKey: .type)
    }
  }
  
  struct Response: Codable, Equatable {
    let accessToken: TokenEntity
    let refreshToken: TokenEntity
  }
}
