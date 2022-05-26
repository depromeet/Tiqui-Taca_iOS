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
  typealias State = MyPageState
  typealias Action = MyPageAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let route: State.Route?
    let myInfoViewState: MyInfoState
    let nickname: String
    let phoneNumber: String
    let profileImage: ProfileImage
    let level: Int
    let createdAt: String
    let createDday: Int
    let isAppAlarmOn: Bool
    let rowInfo: [MyPageItemInfo]
    
    init(state: State) {
      route = state.route
      myInfoViewState = state.myInfoViewState
      nickname = state.nickname
      phoneNumber = state.phoneNumber
      profileImage = state.profileImage
      level = state.level
      createdAt = state.createdAt
      createDday = state.createDday
      isAppAlarmOn = state.isAppAlarmOn
      rowInfo = state.rowInfo
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        VStack {
          Text("마이페이지")
            .font(.heading1)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          ZStack(alignment: .bottomTrailing) {
            Image(viewStore.profileImage.imageName)
            NavigationLink(
              destination: {
                ChangeProfileView(
                  store: .init(
                    initialState: .init(
                      nickname: viewStore.nickname,
                      profileImage: viewStore.profileImage
                    ),
                    reducer: changeProfileReducer,
                    environment: .init(
                      appService: AppService(),
                      mainQueue: .main
                    )
                  )
                )
              }, label: {
                Image("edit")
              }
            )
          }
          
          Text(viewStore.nickname)
            .font(.heading2)
          
          Text("최초가입일 \(viewStore.createdAt) / 티키타카와 +\(String(viewStore.createDday))일 째")
            .font(.body7)
            .foregroundColor(.white900)
          
          Button {
            // popup 띄우기
          } label: {
            Image("rating\(viewStore.level)")
          }
        }
        .padding(.spacingL)
        .foregroundColor(.white)
        .background(Color.black800)
        
        ForEach(viewStore.rowInfo) { item in
          MypageRow(rowInfo: item)
            .onTapGesture {
              viewStore.send(.setRoute(item.itemType))
            }
        }
        .padding([.leading, .trailing], .spacingS)
        
        Spacer()
      }
      .fullScreenCover(
        item: viewStore.binding(
          get: \.route,
          send: MyPageAction.setRoute
        )
      ) { route in
        switch route {
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
          EmptyView()
        }
      }
      .navigationBarTitle("", displayMode: .inline)
      .navigationBarHidden(true)
      .background(Color.white)
      .onAppear {
        viewStore.send(.getProfileInfo)
      }
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
    .previewInterfaceOrientation(.portrait)
  }
}
