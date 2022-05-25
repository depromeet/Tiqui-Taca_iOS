//
//  MyPageItem.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/26.
//

import SwiftUI

struct MypageRow: View {
  let rowInfo: MyPageItemInfo
  @State var togglePressed = false
  
  var body: some View {
    HStack {
      Image(rowInfo.imageName)
      
      Text(rowInfo.title)
        .font(.subtitle3)
        .foregroundColor(.black900)
      
      Toggle("", isOn: $togglePressed)
        .toggleStyle(SwitchToggleStyle(tint: .blue900))
        .opacity(rowInfo.toggleVisible ? 1 : 0)
      
      if rowInfo.description != nil {
        Text("v. \(rowInfo.description ?? "0")")
          .font(.subtitle3)
          .foregroundColor(.blue900)
          .frame(width: 80)
      }
    }
    .background(Color.white)
    .frame(maxWidth: .infinity)
  }
}
