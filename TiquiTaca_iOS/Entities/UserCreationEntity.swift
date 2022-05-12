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
  }
  
  struct Response: Codable, Equatable {
    let accessToken: TokenEntity
    let refreshToken: TokenEntity
  }
}
