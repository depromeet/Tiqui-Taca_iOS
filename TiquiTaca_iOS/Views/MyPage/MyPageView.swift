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
  typealias MyState = MyPageState
  typealias Action = MyPageAction
  
  private let store: Store<MyState, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @State private var togglePressed = false
  
  struct ViewState: Equatable {
    let route: MyState.Route?
    let myInfoViewState: MyInfoState
    let myPageItemStates: IdentifiedArrayOf<MyPageItemState>
    let nickname: String
    let phoneNumber: String
    let profileImage: ProfileImage
    let level: Int
    let createdAt: String
    let createDday: Int
    let isAppAlarmOn: Bool
    
    init(state: MyState) {
      route = state.route
      myInfoViewState = state.myInfoViewState
      myPageItemStates = state.myPageItemStates
      nickname = state.nickname
      phoneNumber = state.phoneNumber
      profileImage = state.profileImage
      level = state.level
      createdAt = state.createdAt
      createDday = state.createDday
      isAppAlarmOn = state.isAppAlarmOn
    }
  }
  
  init(store: Store<MyState, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
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
                store: store.scope(
                  state: \.changeProfileViewState,
                  action: MyPageAction.changeProfileView
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
      
      ForEachStore(
        store.scope(
          state: \.myPageItemStates,
          action: Action.mypageItem(id: action:)
        ), content: { store in
          MypageItem.init(store: store)
        }
      )
      .onTapGesture {
        viewStore.send(.setRoute(item.itemType))
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
    .navigationTitle("마이페이지")
    .background(Color.white)
    .onAppear {
      viewStore.send(.getProfileInfo)
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
