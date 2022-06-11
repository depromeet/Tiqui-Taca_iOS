//
//  LetterSummaryEntity.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/09.
//
import TTNetworkModule

enum LetterSummaryEntity {
  struct Response: Codable, Equatable, Identifiable {
    let receiver: UserEntity.Response?
    let id: String?
    let latestTime: String?
    let latestMessage: String?
    let iWatch: Bool?
    
    enum CodingKeys: String, CodingKey {
      case receiver
      case id = "_id"
      case latestTime
      case latestMessage
      case iWatch
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      receiver = try? container.decode(UserEntity.Response.self, forKey: .receiver)
      id = try? container.decode(String.self, forKey: .id)
      latestTime = try? container.decode(String.self, forKey: .latestTime)
      latestMessage = try? container.decode(String.self, forKey: .latestMessage)
      iWatch = try? container.decode(Bool.self, forKey: .iWatch)
    }
  }
}
