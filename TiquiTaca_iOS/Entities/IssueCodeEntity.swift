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
    let expire: Int
  }
}
