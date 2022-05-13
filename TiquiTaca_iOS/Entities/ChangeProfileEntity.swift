//
//  ChangeProfileEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/14.
//

import TTNetworkModule

enum ChangeProfileEntity {
  struct Request: Codable, JSONConvertible {
    let nickname: String
    let profile: ProfileType
  }
  
  struct Response: Codable, Equatable {
  }
}
