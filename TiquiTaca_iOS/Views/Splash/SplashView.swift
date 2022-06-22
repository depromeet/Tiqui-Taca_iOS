//
//  SplashView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI

struct SplashView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 24) {
      Image("SplashLogo")
      Image("SplashLogoText")
    }
    .hCenter()
    .vCenter()
    .ignoresSafeArea()
    .background(Color.black800)
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
