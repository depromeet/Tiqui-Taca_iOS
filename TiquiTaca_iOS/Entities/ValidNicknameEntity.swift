//
//  ValidNicknameEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/13.
//

import TTNetworkModule

enum ValidNicknameEntity {
  struct Response: Codable, Equatable {
    let myRoomExist: Bool
    let nicknameExist: Bool
    let canChange: Bool
  }
}
