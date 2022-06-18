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
    let noticeViewState: NoticeState
    let nickname: String
    let phoneNumber: String
    let profileImage: ProfileImage
    let level: Int
    let lightningScore: Int
    let createdAt: String
    let createDday: Int
    let isAppAlarmOn: Bool
    let toastPresented: Bool
    
    init(state: MyState) {
      route = state.route
      myInfoViewState = state.myInfoViewState
      myPageItemStates = state.myPageItemStates
      noticeViewState = state.noticeViewState
      nickname = state.nickname
      phoneNumber = state.phoneNumber
      profileImage = state.profileImage
      level = state.level
      lightningScore = state.lightningScore
      createdAt = state.createdAt
      createDday = state.createDday
      isAppAlarmOn = state.isAppAlarmOn
      toastPresented = state.toastPresented
    }
  }
  
  init(store: Store<MyState, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        Text("마이페이지")
          .font(.heading1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, .spacingM)
          .padding(.top, .spacingXS)
        
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
        .padding(.bottom, .spacingM)
        
        Text(viewStore.nickname)
          .font(.heading2)
          .padding(.bottom, .spacingXS)
        
        Text("최초가입일 \(viewStore.createdAt) / 티키타카와 +\(String(viewStore.createDday))일 째")
          .font(.body7)
          .foregroundColor(.white900)
          .padding(.bottom, 9)
        
        Button {
          viewStore.send(.setRoute(.levelInfo))
          UIView.setAnimationsEnabled(false)
        } label: {
          Image("rating\(viewStore.level)")
        }
      }
      .padding(.spacingL)
      .foregroundColor(.white)
      .background(Color.black800)
      
      Rectangle().fill(Color.white)
        .frame(height: 12)
      
      ForEachStore(
        store.scope(
          state: \.myPageItemStates,
          action: Action.mypageItem(id: action:)
        ), content: { store in
          MypageItem.init(store: store)
        }
      )
      
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
        NoticeView(store: store.scope(
          state: \.noticeViewState,
          action: MyPageAction.noticeView
        ))
      case .myTermsOfServiceView:
        MyTermsOfServiceView()
      case .csCenterView:
        CsCenterView()
        
      case .levelInfo:
        AlertView(lightningScore: viewStore.lightningScore)
        .background(BackgroundTransparentView())
      default:
        EmptyView()
      }
    }
    .popup(
      isPresented: viewStore.binding(
        get: \.toastPresented,
        send: MyPageAction.dismissToast
      ),
      type: .floater(
        verticalPadding: 16,
        useSafeAreaInset: true
      ),
      position: .top,
      animation: .easeIn,
      autohideIn: 2
    ) {
      TTToastView(
        title: "프로필을 수정했어요!",
        type: .success
      )
    }
    .navigationTitle("마이페이지")
    .background(Color.white)
    .onAppear {
      viewStore.send(.getProfileInfo)
    }
  }
}

private struct AlertView: View {
  @Environment(\.presentationMode) var presentationMode
  @State var lightningScore: Int
  
  var body: some View {
    ZStack {
      VStack {
        HStack {
          VStack(spacing: 28) {
            VStack(alignment: .center, spacing: .spacingXS) {
              Text("회원 등급 안내")
                .font(.heading3)
                .foregroundColor(.white)
              
              Text("적극적인 대화와 소통을 통해 아이템을 받을 수 있어요!\n계속 모으다보면 혜택이 있을지도...?")
                .multilineTextAlignment(.center)
                .font(.body7)
                .foregroundColor(.white700)
                .frame(height: 34)

              Image("LinearRectangle")
                .overlay {
                  VStack {
                    Text("내가 받은 번개 갯수")
                      .font(.body7)
                      .foregroundColor(.white700)
                    HStack {
                      Image("lightning")
                        .resizable()
                        .frame(width: 24, height: 24)
                      Text("\(lightningScore)")
                        .font(.body4)
                        .foregroundColor(.green500)
                    }
                  }
                }
              
              VStack {
                HStack {
                  Image("ratingLv1")
                  VStack(alignment: .leading) {
                    Text("미니 부부젤라")
                      .font(.subtitle2)
                      .foregroundColor(.white)
                    Text("누적 5개 이상의 번개")
                      .font(.body7)
                      .foregroundColor(.white700)
                  }
                  Spacer()
                  Text("Lv.1")
                    .font(.body4)
                    .foregroundColor(.green500)
                }
                .padding([.leading, .trailing], 24)
                
                HStack {
                  Image("ratingLv2")
                  VStack(alignment: .leading) {
                    Text("근본 확성기")
                      .font(.subtitle2)
                      .foregroundColor(.white)
                    Text("누적 25개 이상의 번개")
                      .font(.body7)
                      .foregroundColor(.white700)
                  }
                  Spacer()
                  Text("Lv.2")
                    .font(.body4)
                    .foregroundColor(.green500)
                }
                .padding([.leading, .trailing], 24)
                
                HStack {
                  Image("ratingLv3")
                  VStack(alignment: .leading) {
                    Text("메가 스피커")
                      .font(.subtitle2)
                      .foregroundColor(.white)
                    Text("누적 100개 이상의 번개")
                      .font(.body7)
                      .foregroundColor(.white700)
                  }
                  Spacer()
                  Text("Lv.3")
                    .font(.body4)
                    .foregroundColor(.green500)
                }
                .padding([.leading, .trailing], 24)
              }
            }
            .padding(EdgeInsets(top: 48, leading: .spacingL, bottom: 0, trailing: .spacingL))
            
            Button {
              presentationMode.wrappedValue.dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.setAnimationsEnabled(true)
              }
            } label: {
              Text("닫기")
                .font(.subtitle1)
                .padding(17)
                .frame(maxWidth: .infinity)
                .background(Color.white100)
                .cornerRadius(8)
            }
            .foregroundColor(.black700)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing, .bottom], 32)
          }
        }
        .frame(maxWidth: .infinity, minHeight: 500)
        .background(RoundedRectangle(cornerRadius: 32).fill(Color.black800.opacity(1)))
      }
    }
    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
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
