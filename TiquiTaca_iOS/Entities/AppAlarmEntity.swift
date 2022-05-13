//
//  AppAlarmEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/11.
//
import TTNetworkModule

enum AppAlarmEntity {
  struct Response: Codable, Equatable {
    let appAlarm: Bool
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      appAlarm = (try? container.decode(Bool.self, forKey: .appAlarm)) ?? false
    }
  }
}
