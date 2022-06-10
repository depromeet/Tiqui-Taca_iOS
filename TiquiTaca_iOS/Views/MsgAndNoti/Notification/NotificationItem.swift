//
//  NotificationItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import SwiftUI

struct NotificationItem: View {
  let notification: NotificationResponse
  
  var body: some View {
    HStack(alignment: .top, spacing: .spacingS) {
      Image(notification.type?.imageName ?? "")
        .resizable()
        .frame(width: 32, height: 32)
        .padding(.top, .spacingXS)
      
      VStack(alignment: .leading, spacing: .spacingXXS) {
        Text(notification.title)
          .font(.body1)
          .foregroundColor(.black900)
          .lineLimit(2)
        HStack {
          Text(notification.subTitle)
            .font(.body7)
            .foregroundColor(.black100)
          Spacer()
          Text(notification.createdAt.relativeTimeAbbreviated)
            .font(.body5)
            .foregroundColor(.white800)
        }
      }
    }
    .padding(.vertical, .spacingXL)
    .padding(.horizontal, .spacingM)
    .background(notification.isRead ? Color.white100 : Color.white)
  }
}

struct NotificationItem_Previews: PreviewProvider {
  static var previews: some View {
    NotificationItem(notification: NotificationResponse())
      .previewLayout(.sizeThatFits)
  }
}
