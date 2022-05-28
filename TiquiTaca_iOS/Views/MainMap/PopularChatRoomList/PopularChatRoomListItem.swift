//
//  PopularChatRoomListItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/28.
//

import SwiftUI

struct PopularChatRoomListItem: View {
  
  var body: some View {
    HStack {
      ZStack {
        Image("colorStar")
        Text("1")
      }
      VStack {
        Text("한양대학교")
        Text("대학교 | 900m")
      }
      VStack {
        Image("peopleColor")
          .resizable()
          .frame(width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
        Text("300명")
      }
    }
  }
}

struct PopularChatRoomListItem_Previews: PreviewProvider {
  static var previews: some View {
    PopularChatRoomListItem()
  }
}
