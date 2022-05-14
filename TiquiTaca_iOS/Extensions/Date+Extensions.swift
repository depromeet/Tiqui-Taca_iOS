//
//  Date+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/14.
//

import Foundation

enum DateFormatType: String{
	case HHmm = "HH:mm"
}

extension Date {
	func convertFormatType(type: DateFormatType) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = type.rawValue
		return dateFormatter.date(from: "\(self)") ?? Date()
	}
}
