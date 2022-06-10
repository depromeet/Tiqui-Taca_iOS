//
//  NotificationResponse.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import Foundation

struct NotificationResponse: Codable {
  let id: String
  let deepLink: String
  let title: String
  let subTitle: String
  let type: NotificationType?
  let createdAt: Date
  let isRead: Bool
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case deepLink
    case title
    case subTitle
    case type = "alarmType"
    case createdAt
    case isRead = "iWatch"
  }
  
  init() {
    id = ""
    deepLink = ""
    title = ""
    subTitle = ""
    type = nil
    createdAt = Date()
    isRead = false
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? ""
    deepLink = (try? container.decode(String.self, forKey: .deepLink)) ?? ""
    title = (try? container.decode(String.self, forKey: .title)) ?? ""
    subTitle = (try? container.decode(String.self, forKey: .subTitle)) ?? ""
    type = try? container.decode(NotificationType.self, forKey: .type)
    createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
    isRead = (try? container.decode(Bool.self, forKey: .isRead)) ?? false
  }
}

extension NotificationResponse: Equatable, Identifiable {}
