//
//  PopularChatRoomListItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import SwiftUI

struct PopularChatRoomListItem: View {
  var body: some View {
    HStack(spacing: .spacingS) {
      ZStack {
        Image("colorStar")
          .resizable()
          .frame(width: 32, height: 32)
          .padding(.spacingXXS)
        Text("1")
          .font(.heading3)
      }
      VStack(alignment: .leading, spacing: .spacingXXXS) {
        Text("한양대학교")
          .font(.heading3)
          .foregroundColor(.white)
        Text("대학교" + " | " + "900" + "m")
          .font(.body3)
          .foregroundColor(.black100)
      }
      Spacer()
      VStack(spacing: 0) {
        Image("peopleColor")
          .resizable()
          .frame(width: 24, height: 24)
        Text("300" + "명")
          .font(.subtitle4)
          .foregroundColor(.white500)
      }
    }
    .padding(.vertical, .spacingS)
    .padding(.horizontal, .spacingXL)
  }
}

struct PopularChatRoomListItem_Previews: PreviewProvider {
  static var previews: some View {
    PopularChatRoomListItem()
      .background(Color.black700)
      .previewLayout(.sizeThatFits)
  }
}
