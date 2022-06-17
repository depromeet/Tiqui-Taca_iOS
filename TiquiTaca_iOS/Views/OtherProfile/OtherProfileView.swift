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
  var sendLetter: ((UserEntity.Response?) -> Void)?
  // var completionHandler: (() -> Void)? = nil // 파라미터로 어떤 행동을 했는지 추가
  
  struct ViewState: Equatable {
    let userInfo: UserEntity.Response?
    let currentAction: OtherProfileState.Action
    let completeAction: OtherProfileState.Action
    let showProfile: Bool
    let showPopup: Bool
    let showAlreadySendLightning: Bool
    
    init(state: OPState) {
      userInfo = state.userInfo
      currentAction = state.currentAction
      completeAction = state.completeAction
      showProfile = state.showProfile
      showPopup = state.showPopup
      showAlreadySendLightning = state.showAlreadySendLightning
    }
  }
  
  init(store: Store<OPState, OPAction>, showView: Binding<Bool>, sendLetter: @escaping ((UserEntity.Response?) -> Void)) {
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
            switch viewStore.currentAction {
            case .block:
              viewStore.send(.userBlock)
            case .unblock:
              viewStore.send(.userUnblock)
            case .report:
              viewStore.send(.userReport)
            case .lightning:
              viewStore.send(.userSendLightning)
            default:
              break
            }
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
      
      if viewStore.showAlreadySendLightning {
        TTPopupView.init(
          popUpCase: .oneLineTwoButton,
          title: "이미 해당 유저에게 번개를 줬어요.",
          subtitle: "다시 번개를 주려면 최소 1일 뒤에 줄 수 있어요!",
          leftButtonName: "닫기",
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
    .onReceive(Just(viewStore.completeAction)) { value in
      if value != .none {
        print("complete", value)
        // 이전 뷰에 어떤 것을 했는지 noti?
        removeView()
      }
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
            if viewStore.userInfo?.iBlock == true {
              OtherProfileButton(
                type: .unblock,
                isEnabled: viewStore.userInfo?.status == .normal
              ) {
                viewStore.send(.setShowProfile(false))
                viewStore.send(.setAction(.unblock))
              }
            } else {
              OtherProfileButton(
                type: .block,
                isEnabled: viewStore.userInfo?.canUseFeature ?? true
              ) {
                viewStore.send(.setShowProfile(false))
                viewStore.send(.setAction(.block))
              }
            }
            
            OtherProfileButton(
              type: .report,
              isEnabled: viewStore.userInfo?.canUseFeature ?? true
            ) {
              viewStore.send(.setShowProfile(false))
              viewStore.send(.setAction(.report))
            }
            
            OtherProfileButton(
              type: .letter,
              isEnabled: viewStore.userInfo?.canUseFeature ?? true
            ) {
              sendLetter?(viewStore.userInfo)
              removeView()
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
              if viewStore.userInfo?.canUseFeature == true {
                Image("profileSpark")
                  .resizable()
                  .frame(width: 28, height: 28)
              }
            }
          }
          .buttonStyle(TTButtonLargeGreenStyle())
          .disabled(viewStore.userInfo?.canUseFeature == false)
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
              if viewStore.userInfo?.canUseFeature == true {
                Image("bxLoudspeaker3")
                  .resizable()
                  .frame(width: 32, height: 32)
              }
              VStack(spacing: 2) {
                Text("\(viewStore.userInfo?.nickname ?? "")")
                  .font(.heading2)
                  .foregroundColor(viewStore.userInfo?.canUseFeature == true ? .white : .black50)
                if viewStore.userInfo?.canUseFeature == false {
                  Text( getSubProfileName() )
                    .font(.body8)
                    .foregroundColor(.white)
                }
              }
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
  
  private func getSubProfileName() -> String {
    switch viewStore.userInfo?.status {
    case .forbidden:
      return "(이용제한된 사용자)"
    case .signOut:
      return "(탈퇴 사용자)"
    default:
      return "(차단된 사용자)"
    }
  }
  
  private func getPopupTitle() -> String {
    switch viewStore.currentAction {
    case .block:
      return "해당 사용자를\n차단 하시겠습니까?"
    case .unblock:
      return "해당 사용자를\n차단 해제 하시겠습니까?"
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
    case .unblock:
      return "차단 해제하기"
    case .report:
      return "신고하기"
    case .lightning:
      return "즐거웠어요!"
    default:
      return ""
    }
  }
}

struct OtherProfileButton: View {
  var type: OtherProfileState.Action
  var isEnabled: Bool
  var action: (() -> Void)
  
  var body: some View {
    Button {
      action()
    } label: {
      VStack(alignment: .center) {
        Image(getImageName())
          .resizable()
          .frame(width: 48, height: 48)
        Text(getTitleName())
          .font(.body2)
          .foregroundColor(isEnabled ? .white50 : .white900)
      }
    }
    .disabled(!isEnabled)
  }
  
  func getImageName() -> String {
    switch type {
    case .block:
      return isEnabled ? "profileBlock" : "profileBlockDisabled"
    case .unblock:
      return isEnabled ? "profileUnblock" : "profileBlockDisabled"
    case .report:
      return isEnabled ? "report" : "reportDisabled"
    case .letter:
      return isEnabled ? "note" : "noteDisabled"
    default:
      return ""
    }
  }
  
  func getTitleName() -> String {
    switch type {
    case .block:
      return "차단"
    case .unblock:
      return "차단 해제"
    case .report:
      return "신고"
    case .letter:
      return "쪽지"
    default:
      return ""
    }
  }
}
