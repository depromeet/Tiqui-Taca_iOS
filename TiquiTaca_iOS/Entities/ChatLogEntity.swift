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
  func isBlind(blockList: [BlockUserEntity.Response]?) -> Bool {
    blockList?.filter{ $0.id == sender?.id }.isEmpty == false ||
    sender?.status == .forbidden
  }
  
  func getChatMessageType(myId: String?) -> ChatMessageType {
    if type == 3 {
      return .date
    } else if sender?.id == myId {
      return .sent
    } else {
      return .receive
    }
  }
  
  func getMessage() -> String {
    if type == 3 {
      if Date().getDateString(format: .yyyyMMdd) == message {
        return "오늘"
      } else {
        return message ?? "새 시작"
      }
    }
    
    if sender?.iBlock == true {
      return "차단된 사용자의 메세지입니다."
    }
    
    switch sender?.status {
    case .forbidden:
      return "이용제한된 사용자의 메세지입니다."
    case .normal, .signOut:
      return message ?? "잘못된 메세지 입니다"
    default:
      return "잘못된 메세지 입니다"
    }
  }
}
