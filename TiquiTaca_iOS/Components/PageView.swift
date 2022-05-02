//
//  PageView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/02.
//

import SwiftUI

struct PageView: View {
  @Binding var currentPage: Int
  
  var body: some View {
    TabView(selection: $currentPage) {
      Image(systemName: "d.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(0)
      Image(systemName: "p.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(1)
      Image(systemName: "m.square.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .tag(2)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
    .background(.white)
    .cornerRadius(16)
  }
}
