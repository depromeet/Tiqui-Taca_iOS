//
//  RoomLikeEntity.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/31.
//

import TTNetworkModule

enum RoomLikeEntity {
  struct Request: Codable, JSONConvertible { }
  struct Response: Codable, Equatable {
    let iFavoritRoom: Bool?
  }
}
