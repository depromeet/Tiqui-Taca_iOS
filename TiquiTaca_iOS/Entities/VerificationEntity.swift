//
//  VerificationEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/30.
//

import TTNetworkModule

enum VerificationEntity {
  struct Request: Codable, JSONConvertible {
    let phoneNumber: String
    let verificationCode: String
  }
  
  struct Response: Codable, Equatable {
    let tempToken: TokenEntity?
    let user: UserEntity.Response?
    let accessToken: TokenEntity?
    let refreshToken: TokenEntity?
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      tempToken = try? container.decode(TokenEntity.self, forKey: .tempToken)
      user = try? container.decode(UserEntity.Response.self, forKey: .user)
      accessToken = try? container.decode(TokenEntity.self, forKey: .accessToken)
      refreshToken = try? container.decode(TokenEntity.self, forKey: .refreshToken)
    }
  }
}
