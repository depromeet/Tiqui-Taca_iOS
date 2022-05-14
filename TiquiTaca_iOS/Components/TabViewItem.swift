//
//  TabViewItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/14.
//

import SwiftUI

enum TabViewItemType {
  case map(Bool)
  case chat(Bool)
  case msgAndNoti(Bool)
  case myPage(Bool)
  
  var image: Image {
    switch self {
    case let .map(isSelected):
      return Image(isSelected ? "map_active" : "map")
    case let .chat(isSelected):
      return Image(isSelected ? "chat_active" : "chat")
    case let .msgAndNoti(isSelected):
      return Image(isSelected ? "letter_active" : "letter")
    case let .myPage(isSelected):
      return Image(isSelected ? "mypage_active" : "mypage")
    }
  }
  
  var text: Text {
    switch self {
    case .map:
      return Text("지도")
    case .chat:
      return Text("채팅")
    case .msgAndNoti:
      return Text("쪽지·알림")
    case .myPage:
      return Text("마이페이지")
    }
  }
}

struct TabViewItem: View {
  var type: TabViewItemType
  
  var body: some View {
    VStack {
      type.image
      type.text
    }
  }
}
