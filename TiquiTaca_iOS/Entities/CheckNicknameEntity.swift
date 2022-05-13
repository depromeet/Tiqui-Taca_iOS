//
//  CheckNicknameEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/12.
//

import TTNetworkModule

enum CheckNicknameEntity {
  struct Request: Codable, JSONConvertible {
    let nickname: String
  }
  
  struct Response: Codable, Equatable {
    let isExist: Bool
  }
}
