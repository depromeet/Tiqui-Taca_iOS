//
//  NotificationType.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import Foundation

enum NotificationType: String, Codable {
  case comment
  case lightning
  case official
  
  var imageName: String {
    switch self {
    case .comment:
      return "alarmReply"
    case .lightning:
      return "alarmSpark"
    case .official:
      return "alarmOfficial"
    }
  }
}
