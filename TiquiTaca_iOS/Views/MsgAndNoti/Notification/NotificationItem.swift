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
        Text("닉네임4ㄴ이;럼;ㅣ넝리;먼ㅇ리;ㅓㅏㄴㅇㄹ;ㅣㅏㅓsdjfl;ksajdflkjsdf;lksjdf;lksjdf;lkasjdfsd;lfjsdl;fkjs;ldfjka;lskdfj")
          .font(.body1)
          .foregroundColor(.black900)
          .lineLimit(2)
        HStack {
          Text("국민대학교")
            .font(.body7)
            .foregroundColor(.black100)
          Spacer()
          Text("12시간 전")
            .font(.body2)
            .foregroundColor(.white800)
        }
      }
    }
    .padding(.vertical, .spacingXL)
    .padding(.horizontal, .spacingM)
    .background(.white)
  }
}

struct NotificationItem_Previews: PreviewProvider {
  static var previews: some View {
    NotificationItem(notification: NotificationResponse())
      .previewLayout(.sizeThatFits)
  }
}
