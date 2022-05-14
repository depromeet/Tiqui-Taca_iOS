//
//  TTType.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/13.
//

import Foundation

enum TTCategory: String, CaseIterable {
	case UNIVERSITY = "대학교"
	case EXHIBITION = "전시회"
	case HANRIVERPRAK = "한강공원"
	
	static func getCategory(key: String) -> String {
		print(key)
		return TTCategory.allCases
			.filter({ "\($0)" == key })
			.first?
			.rawValue ?? "한강공원"
	}
}
