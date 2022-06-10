//
//  OtherProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/07.
//

import Combine
import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct OtherProfileView: View {
  typealias OPState = OtherProfileState
  typealias OPAction = OtherProfileAction
  
  var store: Store<OPState, OPAction>
  @ObservedObject private var viewStore: ViewStore<ViewState, OPAction>
  @Binding var showView: Bool
  var sendLetter: (() -> Void)?
  
  struct ViewState: Equatable {
    let userInfo: UserEntity.Response?
    let currentAction: OtherProfileState.Action
    let showProfile: Bool
    let showPopup: Bool
    
    init(state: OPState) {
      userInfo = state.userInfo
      currentAction = state.currentAction
      showProfile = state.showProfile
      showPopup = state.showPopup
    }
  }
  
  init(store: Store<OPState, OPAction>, showView: Binding<Bool>, sendLetter: @escaping (() -> Void)) {
    self.store = store
    self._showView = showView
    self.sendLetter = sendLetter
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  
  var body: some View {
    ZStack(alignment: .center) {
      Color.black800.opacity(0.7)
        .onTapGesture {
          removeView()
        }
      if viewStore.showPopup {
        TTPopupView.init(
          popUpCase: .oneLineTwoButton,
          title: getPopupTitle(),
          subtitle: "",
          leftButtonName: "취소",
          rightButtonName: getPopupRightBtnTitle(),
          confirm: {
            removeView()
          },
          cancel: {
            removeView()
          }
        )
          .padding(.horizontal, 24)
          .overlay(
            Image("bxOnboarding3")
              .resizable()
              .frame(width: 128, height: 128)
              .offset(x: 0, y: -80)
              .opacity(viewStore.currentAction == .lightning ? 1 : 0),
            alignment: .top
          )
      }
    }
    .onReceive(Just(showView)) { value in
      if value { viewStore.send(.fetchUserInfo) }
    }
    .edgesIgnoringSafeArea(.all)
    .fullScreenCover(isPresented: viewStore.binding(
      get: \.showProfile,
      send: OtherProfileAction.setShowProfile
    )) {
      ZStack(alignment: .bottom) {
        Color.clear
        VStack(spacing: 0) {
          HStack(spacing: 32) {
            Button {
              viewStore.send(.setShowProfile(false))
              viewStore.send(.setAction(.block))
            } label: {
              VStack(alignment: .center) {
                Image("profileBlock")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("차단")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
            Button {
              viewStore.send(.setShowProfile(false))
              viewStore.send(.setAction(.report))
            } label: {
              VStack(alignment: .center) {
                Image("report")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("신고")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
            Button {
              sendLetter?()
              removeView()
            } label: {
              VStack(alignment: .center) {
                Image("note")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("쪽지")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
          }
          .hCenter()
          .padding(.top, 138)
          .padding(.bottom, 24)
          
          Button {
            viewStore.send(.setShowProfile(false))
            viewStore.send(.setAction(.lightning))
          } label: {
            HStack(spacing: 0) {
              Text("해당 유저에게 번개 주기")
                .font(.subtitle1)
                .foregroundColor(.black900)
              Image("profileSpark")
                .resizable()
                .frame(width: 28, height: 28)
            }
          }
          .buttonStyle(TTButtonLargeGreenStyle())
          .padding(.horizontal, 24)
          
          VStack { }
            .hCenter()
            .frame(height: 44)
        }
        .background(Color.black700)
        .cornerRadius(48, corners: [.topLeft, .topRight])
        .overlay(
          VStack(spacing: 6) {
            ZStack(alignment: .center) {
              Image("profileRectangle")
                .resizable()
                .frame(width: 110, height: 110)
              Image(viewStore.userInfo?.profile.imageName ?? "character18")
                .resizable()
                .frame(width: 104, height: 104)
                .padding(.leading, 1)
                .padding(.top, 2)
            }
            
            HStack(alignment: .center, spacing: 4) {
              Image("bxLoudspeaker3")
                .resizable()
                .frame(width: 32, height: 32)
              Text("\(viewStore.userInfo?.nickname ?? "")")
                .font(.heading2)
                .foregroundColor(.white)
            }
          }
          .padding(.top, -32),
          alignment: .top
        )
      }
      .edgesIgnoringSafeArea(.all)
      .background(BackgroundClearView().onTapGesture {
        removeView()
      })
    }
  }
  
  private func removeView() {
    viewStore.send(.setAction(.none))
    viewStore.send(.setShowProfile(false))
    showView = false
  }
  
  private func getPopupTitle() -> String {
    switch viewStore.currentAction {
    case .block:
      return "해당 사용자를\n차단 하시겠습니까?"
    case .report:
      return "해당 사용자를\n신고 하시겠습니까?"
    case .lightning:
      return "\(viewStore.userInfo?.nickname ?? "사용자")님과의 티키타카가\n즐거웠나요?"
    default:
      return ""
    }
  }
  
  private func getPopupRightBtnTitle() -> String {
    switch viewStore.currentAction {
    case .block:
      return "차단하기"
    case .report:
      return "신고하기"
    case .lightning:
      return "즐거웠어요!"
    default:
      return ""
    }
  }
}

