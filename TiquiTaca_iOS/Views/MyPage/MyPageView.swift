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
                  })
                {
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
          .padding(.spacingL)
          .foregroundColor(.white)
          .background(Color.black800)
          
          ForEach(0..<viewStore.rowInfo.count) { idx in
            MypageRow(rowInfo: viewStore.rowInfo[idx])
              .onTapGesture(perform: {
                viewStore.send(.selectSheetIndex(idx))
              })
          }
          .padding([.leading, .trailing], .spacingS)
          Spacer()
          
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
        .onAppear(
          perform: {
            viewStore.send(.getProfileInfo)
          })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .background(Color.white)
      }
    }
  }
}

struct MypageRow: View {
  var rowInfo: MypageRowInfo
  //  @State var togglePressed = false
  var body: some View {
    HStack {
      Image(rowInfo.imageName)
      
      Text(rowInfo.title)
        .font(.subtitle3)
        .foregroundColor(.black900)
      
      Toggle("", isOn: .constant(false))//$togglePressed)
        .toggleStyle(SwitchToggleStyle(tint: .blue900))
        .opacity(rowInfo.toggleVisible ? 1 : 0)
      
      Text("v. \(rowInfo.version)")
        .font(.subtitle3)
        .foregroundColor(.blue900)
        .opacity(rowInfo.version.isEmpty ? 0 : 1)
        .frame(width: rowInfo.version.isEmpty ? 0 : 80)
    }
    .background(Color.white)
    .frame(maxWidth: .infinity)
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
    .previewInterfaceOrientation(.portrait)
  }
}
