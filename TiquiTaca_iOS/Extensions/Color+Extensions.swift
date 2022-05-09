//
//  Color+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/07.
//

import Foundation
import SwiftUI

public extension Color {
	var uiColor: UIColor {
		guard let cgColor = self.cgColor else { return .white }
		return UIColor(cgColor: cgColor)
	}
}
