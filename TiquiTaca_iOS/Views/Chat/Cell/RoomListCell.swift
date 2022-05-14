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
	let ranking: Int?
	let info: RoomInfoEntity.Response
	let type: RoomListType
	
	init(ranking: Int? = nil, info: RoomInfoEntity.Response, type: RoomListType) {
		self.ranking = ranking
		self.info = info
		self.type = type
	}
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 16) {
				if type == .popular {
					PopularMark(ranking: ranking ?? 1)
				}
				
				VStack(spacing: 2) {
					HStack(spacing: 8) {
						Text("\(info.name ?? "이름없음")")
							.foregroundColor(.black600)
							.font(.subtitle2)
						Text(TTCategory.getCategory(key: info.category ?? "ETC") )
							.foregroundColor(.black100)
							.font(.body6)
							.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
							.background(Color.white100)
							.cornerRadius(16)
					}
						.hLeading()
					Text("현재 \(info.userCount ?? 0)명이 티키타카 중 :)")
						.foregroundColor(.white800)
						.font(.body3)
						.hLeading()
				}
					.hLeading()
				
				Image("rightArrow")
					.resizable()
					.frame(width: 32, height: 32)
			}
				.hLeading()
				.contentShape(Rectangle())
				.padding([.leading, .trailing], 24)
				.padding([.top, .bottom], 12)
			RoomListCellDivider()
		}
	}
}


// MARK: Popular Mark
private struct PopularMark: View {
	let ranking: Int
	var body: some View {
		Image(ranking < 4 ? "colorStar" : "star")
			.resizable()
			.scaledToFit()
			.frame(width: 32, height: 32)
			.overlay(
				Text("\(ranking)")
					.foregroundColor(ranking < 4 ? .black800: .black200)
					.font(.heading3)
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
			ranking: 1,
			info: RoomInfoEntity.Response(),
			type: .popular
		)
	}
}
