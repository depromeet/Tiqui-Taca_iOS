//
//  RoomInfoEntity.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/10.
//

import TTNetworkModule

enum RoomInfoEntity {
	struct Request: Codable, JSONConvertible { }
	
	struct Response: Codable, Equatable, Identifiable {
		let id: String?
		let name: String?
		let category: String?
		let userCount: Int?
		
		enum CodingKeys: String, CodingKey {
			case id = "_id"
			case name
			case category
			case userCount
		}
		init() {
			id = ""
			name = ""
			category = ""
			userCount = 1
		}
		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			id = (try? container.decode(String.self, forKey: .id)) ?? ""
			name = (try? container.decode(String.self, forKey: .name)) ?? ""
			category = (try? container.decode(String.self, forKey: .category)) ?? ""
			userCount = (try? container.decode(Int.self, forKey: .userCount)) ?? 1
		}
	}
}
