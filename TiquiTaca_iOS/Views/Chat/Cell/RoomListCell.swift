//
//  RoomListCell.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/08.
//

import SwiftUI

enum RoomListType {
	case like
	case popular
}

struct RoomListCell: View {
	let index: Int
	var body: some View {
		VStack {
			Text("Row \(index)")
		}
			.hLeading()
			.padding([.leading, .trailing], 24)
			.frame(height: 60)
	}
}

struct RoomListCell_Previews: PreviewProvider {
    static var previews: some View {
			RoomListCell(index: 1)
    }
}
