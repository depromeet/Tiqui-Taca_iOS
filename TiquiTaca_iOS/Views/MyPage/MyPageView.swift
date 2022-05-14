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
              .font(.heading1)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(viewStore.profileImage.imageName)
              .overlay(
                NavigationLink(
                  destination: {
                    ChangeProfileView(store: .init(
                      initialState: ChangeProfileState(
                        nickname: viewStore.nickname,
                        profileImage: viewStore.profileImage
                      ),
                      reducer: changeProfileReducer,
                      environment: ChangeProfileEnvironment(
                        appService: AppService(),
                        mainQueue: .main
                      ))
                    )
                  }
                ) {
                  Image("edit")
                }
                  .alignmentGuide(.bottom) { $0[.bottom] }
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
              )
            Text(viewStore.nickname)
              .font(.heading2)
            
            Text("최초가입일 \(viewStore.createdAt) / 티키타카와 +\(String(viewStore.createDday))일 째")
              .font(.body7)
              .foregroundColor(.white900)
            
            Button {
              
            } label: {
              Image("rating\(viewStore.level)")
            }
          }
          .padding(.spacingXL)
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
                    MyInfoView(store: store.scope(
                      state: \.myInfoViewState,
                      action: MyPageAction.myInfoView
                    ))
                  case .blockHistoryView:
                    MyBlockHistoryView(store: .init(
                      initialState: MyBlockHistoryState(),
                      reducer: myBlockHistoryReducer,
                      environment: MyBlockHistoryEnvironment(
                        appService: .init(),
                        mainQueue: .main
                      ))
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
        .onAppear(
          perform: {
            viewStore.send(.getProfileInfo)
          })
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
        .font(.subtitle3)
        .foregroundColor(.black900)
      
      Toggle("", isOn: $togglePressed)
        .toggleStyle(SwitchToggleStyle(tint: .blue900))
        .opacity(toggleVisible ? 1 : 0)
      
      Text("v. \(version)")
        .font(.subtitle3)
        .foregroundColor(.blue900)
        .opacity(version.isEmpty ? 0 : 1)
        .frame(width: version.isEmpty ? 0 : 80)
    }
  }
}

struct MyPageView_Previews: PreviewProvider {
  static var previews: some View {
    MyPageView(
      store: .init(
        initialState: MyPageState(),
        reducer: myPageReducer,
        environment: MyPageEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
