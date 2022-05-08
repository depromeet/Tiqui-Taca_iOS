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
	let type: RoomListType
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 16) {
				if type == .popular {
					PopularMark(index: index)
				}
				
				VStack(spacing: 2) {
					HStack(spacing: 8) {
						Text("장소 Row\(index + 1)")
							.foregroundColor(.black600)
							.font(.system(size: 16, weight: .semibold, design: .default))
						Text("대학교")
							.foregroundColor(.black100)
							.font(.system(size: 12, weight: .semibold, design: .default))
							.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
							.background(Color.white100)
							.cornerRadius(16)
					}
						.hLeading()
					Text("현재 200명이 보고 있는 중 :)")
						.foregroundColor(.white800)
						.font(.system(size: 14, weight: .semibold, design: .default))
						.hLeading()
				}
					.hLeading()
				
				Image("rightArrow")
					.resizable()
					.frame(width: 32, height: 32)
			}
				.hLeading()
				.padding([.leading, .trailing], 24)
				.padding([.top, .bottom], 12)
			RoomListCellDivider()
		}
	}
}

// MARK: Popular Mark
private struct PopularMark: View {
	let index: Int
	var body: some View {
		Image(index < 3 ? "colorStar" : "star")
			.resizable()
			.scaledToFit()
			.frame(width: 32, height: 32)
			.overlay(
				Text("\(index + 1)")
					.foregroundColor(.black800)
					.font(.system(size: 18, weight: .semibold, design: .default))
			)
	}
}



// MARK: Divider
private struct RoomListCellDivider: View {
	var body: some View {
		VStack { }
			.hCenter()
			.frame(height: 1)
			.background(Color.white50)
	}
}

struct RoomListCell_Previews: PreviewProvider {
	static var previews: some View {
		RoomListCell(
			index: 1,
			type: .popular
		)
	}
}
