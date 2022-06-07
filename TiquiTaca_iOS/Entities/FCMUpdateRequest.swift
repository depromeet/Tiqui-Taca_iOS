//
//  FCMUpdateRequest.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/07.
//

import Foundation
import TTNetworkModule

struct FCMUpdateRequest: Codable, JSONConvertible {
  let fcmToken: String
  
  enum CodingKeys: String, CodingKey {
    case fcmToken = "FCMToken"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(fcmToken, forKey: .fcmToken)
  }
}
