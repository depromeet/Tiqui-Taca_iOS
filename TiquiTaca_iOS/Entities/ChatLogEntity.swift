//
//  ChatLogEntity.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//

import TTNetworkModule



enum ChatLogEntity {
	struct Request: Codable, JSONConvertible { }
	
	struct Response: Codable, Equatable, Identifiable {
		
		var id: String?
		// var sender: ChatSenderEntity?
		var inside: Bool?
		var type: Int?
		var message: String?
		var createdAt: Date?
		
		enum CodingKeys: String, CodingKey {
			case id = "_id"
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
			inside = (try? container.decode(Bool.self, forKey: .inside)) ?? true
			type = (try? container.decode(Int.self, forKey: .type)) ?? 1
			message = (try? container.decode(String.self, forKey: .message)) ?? "잘못된 메세지입니다"
			createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date.init()
		}
	}
}

