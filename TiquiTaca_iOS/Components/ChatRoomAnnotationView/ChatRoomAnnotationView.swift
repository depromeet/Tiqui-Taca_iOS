//
//  ChatRoomAnnotation.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import SwiftUI

struct ChatRoomAnnotationView: View {
  let info: ChatRoomAnnotationInfo
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 18)
        .frame(width: 69, height: 59)
        .overlay(
          RoundedRectangle(cornerRadius: 18)
            .stroke(Color.white500, lineWidth: 1)
        )
        .padding(.top, 30)
      VStack(spacing: 0) {
        Image(info.category.imageName)
        Text("\(info.userCount)명")
          .foregroundColor(.white)
          .font(.subtitle4)
        Text(info.name)
          .foregroundColor(.white700)
          .font(.body8)
      }
      .lineLimit(1)
      .padding(.bottom, .spacingXS)
      .padding(.horizontal, .spacingS)
    }
    .frame(width: 71, height: 89)
  }
}

struct ChatRoomAnnotationView_Previews: PreviewProvider {
  static var previews: some View {
    ChatRoomAnnotationView(
      info: .init(
        id: "",
        name: "여의도한강공원",
        category: .hanriverpark,
        radius: 0,
        userCount: 300,
        latitude: 0.0,
        longitude: 0.0
      )
    )
    .previewLayout(.sizeThatFits)
  }
}
