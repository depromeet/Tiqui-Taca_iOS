//
//  View+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import Foundation
import SwiftUI

extension View {
	// 수평 정렬
	func hLeading() -> some View {
		self.frame(maxWidth: .infinity, alignment: .leading)
	}
		
	func hTrailing() -> some View {
		self.frame(maxWidth: .infinity, alignment: .trailing)
	}
		
	func hCenter() -> some View {
		self.frame(maxWidth: .infinity, alignment: .center)
	}
		
	// 수직 정렬
	func vTop() -> some View {
		self.frame(maxHeight: .infinity, alignment: .top)
	}
		
	func vBottom() -> some View {
		self.frame(maxHeight: .infinity, alignment: .bottom)
	}
		
	func vCenter() -> some View {
		self.frame(maxHeight: .infinity, alignment: .center)
	}
}
