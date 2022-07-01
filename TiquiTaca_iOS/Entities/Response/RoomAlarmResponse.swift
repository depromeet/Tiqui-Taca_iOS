//
//  RoomAlarmResponse.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/11.
//

import Foundation
import TTNetworkModule

struct RoomAlarmResponse: Codable, JSONConvertible {
  let isChatAlarmOn: Bool
}
