//
//  ChatLogEntity.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//

import TTNetworkModule

enum ChatLogEntity {
  struct Request: Codable, JSONConvertible {
  }
  
  struct Response: Codable, Equatable, Identifiable {
    var id: String?
    var sender: UserEntity.Response?
    var inside: Bool?
    var type: Int?
    var message: String?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case sender
      case inside
      case type
      case message
      case createdAt
    }
    init() {
      id = ""
      inside = true
      type = 1
      message = "테스트입니다"
      createdAt = nil
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = (try? container.decode(String.self, forKey: .id)) ?? ""
      sender = (try? container.decode(UserEntity.Response.self, forKey: .sender))
      inside = (try? container.decode(Bool.self, forKey: .inside)) ?? true
      type = (try? container.decode(Int.self, forKey: .type)) ?? 1
      message = (try? container.decode(String.self, forKey: .message)) ?? "잘못된 메세지입니다"
      createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? "00:00"
    }
  }
}

extension ChatLogEntity.Response {
  func getMessage() -> String {
    // date
    if type == 3 {
      if Date().getDateString(format: .yyyyMMdd) == message {
        return "오늘"
      } else {
        return message ?? "새 시작"
      }
    }
    
    switch sender?.status {
    case .forbidden:
      return ""
    case .signOut:
      return ""
    case .normal:
      return ""
    default:
      return ""
    }
  }
}
