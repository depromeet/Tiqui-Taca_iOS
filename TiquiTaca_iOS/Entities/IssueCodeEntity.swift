//
//  IssueCodeEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/30.
//

import TTNetworkModule

enum IssueCodeEntity {
  struct Request: Codable, JSONConvertible {
    let phoneNumber: String
  }
  
  struct Response: Codable, Equatable {
    let verficiationCode: String // 인증코드 임시 확인을 위한 파라미터
    let expire: Int
  }
}
