//
//  MyPageView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
  let store: Store<MyPageState, MyPageAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        VStack {
          Text("마이페이지")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, .spacing24)
          
          VStack {
            Image(viewStore.profileImage)
              .overlay(
                Button {
  
                } label: {
                  Image("edit")
                }
                  .alignmentGuide(.bottom) { $0[.bottom] }
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
              )
            Text(viewStore.nickName)
            Text("최초가입일 \(viewStore.createdAt) / 티키타카와 +\(viewStore.createDday)일 째")
            Text("뱃지")
          }
          
          List {
            MypageRow(imageName: "myInfo", title: "내 정보")
            MypageRow(imageName: "alarm", title: "알림설정", toggleVisible: true, togglePressed: viewStore.isAppAlarmOn)
            MypageRow(imageName: "block", title: "차단 이력")
            MypageRow(imageName: "info", title: "공지사항")
            MypageRow(imageName: "terms", title: "이용약관")
            MypageRow(imageName: "center", title: "고객센터")
            MypageRow(imageName: "version", title: "버전 정보", version: viewStore.appVersion)
          }
        }
      }
    }
  }
}

struct MypageRow: View {
  var imageName: String
  var title: String
  var version: String = ""
  var toggleVisible: Bool = false
  @State var togglePressed = false
  
  var body: some View {
    HStack {
      Image(imageName)
      Text(title)
      Toggle("", isOn: $togglePressed)
        .toggleStyle(SwitchToggleStyle(tint: .blue900))
        .opacity(toggleVisible ? 1 : 0)
      Text("v. \(version)")
        .foregroundColor(.blue900)
        .opacity(version.isEmpty ? 0 : 1)
    }
  }
}

struct MyPageView_Previews: PreviewProvider {
  static var previews: some View {
    MyPageView(store: .init(
      initialState: MyPageState(),
      reducer: myPageReducer,
      environment: MyPageEnvironment())
    )
  }
}
