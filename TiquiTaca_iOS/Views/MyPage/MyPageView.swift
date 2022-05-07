//
//  MyPageView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct MyPageView: View {
  let store: Store<MyPageState, MyPageAction>
  @State var sheetState: MyPageSheetChoice?
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        VStack {
          VStack {
            Text("마이페이지")
              .frame(maxWidth: .infinity, alignment: .leading)
            Image(viewStore.profileImage)
              .overlay(
                Button {
                  viewStore.send(.selectDetail)
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
          .padding(.spacing24)
          .foregroundColor(.white)
          .background(Color.black800)
          
          
          List {
            Button {
              viewStore.send(.selectSheet(.myInfoView))
            } label: {
              MypageRow(imageName: "myInfo", title: "내 정보")
            }
            MypageRow(imageName: "alarm", title: "알림설정", toggleVisible: true, togglePressed: viewStore.isAppAlarmOn)
            Button {
              viewStore.send(.selectSheet(.blockHistoryView))
            } label: {
              MypageRow(imageName: "block", title: "차단 이력")
            }
            Button {
              viewStore.send(.selectSheet(.noticeView))
            } label: {
              MypageRow(imageName: "info", title: "공지사항")
            }
            Button {
              viewStore.send(.selectSheet(.myTermsOfServiceView))
            } label: {
              MypageRow(imageName: "terms", title: "이용약관")
            }
            Button {
              viewStore.send(.selectSheet(.csCenterView))
            } label: {
              MypageRow(imageName: "center", title: "고객센터")
            }
            MypageRow(imageName: "version", title: "버전 정보", version: viewStore.appVersion)
              .fullScreenCover(
                isPresented: viewStore.binding(
                  get: \.popupPresented,
                  send: MyPageAction.dismissDetail
                ),
                content: {
                  switch viewStore.sheetChoice {
                  case .myInfoView:
                    MyInfoView(store: .init(
                      initialState: MyInfoState(),
                      reducer: myInfoReducer,
                      environment: MyInfoEnvironment())
                    )
                  case .blockHistoryView:
                    MyBlockHistoryView(store: .init(
                      initialState: MyBlockHistoryState(),
                      reducer: myBlockHistoryReducer,
                      environment: MyBlockHistoryEnvironment())
                    )
                  case .noticeView:
                    NoticeView(store: .init(
                      initialState: NoticeState(),
                      reducer: noticeReducer,
                      environment: NoticeEnvironment()))
                    
                  case .myTermsOfServiceView:
                    MyTermsOfServiceView(store: .init(
                      initialState: MyTermsOfServiceState(),
                      reducer: myTermsOfServiceReducer,
                      environment: MyTermsOfServiceEnvironment()))
                    
                  case .csCenterView:
                    CsCenterView()
                  default:
                    CsCenterView()
                  }
                })
          }
          .listStyle(.plain)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
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
        .frame(width: version.isEmpty ? 0 : 80)
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
