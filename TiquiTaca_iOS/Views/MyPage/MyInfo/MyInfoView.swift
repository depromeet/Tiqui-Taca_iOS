//
//  MyInfoView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct MyInfoView: View {
  let store: Store<MyInfoState, MyInfoAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        ScrollView {
          VStack(alignment: .leading, spacing: .spacingS) {
            HStack {
              Text("내 정보")
                .font(.heading1)
                .foregroundColor(.black800)
              
              Spacer()
              
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image("idelete")
                  .resizable()
                  .frame(width: 24, height: 24)
              }
            }
            .padding(EdgeInsets(top: 28, leading: .spacingXL, bottom: 22, trailing: .spacingXL))
            
            Text("회원 정보")
              .font(.subtitle4)
              .foregroundColor(.black800)
              .padding(.leading, .spacingXL)
            
            VStack(alignment: .leading, spacing: 0) {
              MyInfoRow(
                title: "닉네임",
                description: viewStore.nickname
              )
              MyInfoRow(
                title: "휴대폰 번호",
                description: viewStore.phoneNumber)
              
              MyInfoRow(
                title: "최초 가입일",
                description: "\(viewStore.createdAt)"
              )
            }
            .background(Color.white50)
            
            Rectangle().fill(Color.white)
              .frame(height: 56)
            
            Text("로그인 관리")
              .font(.subtitle4)
              .foregroundColor(.black800)
              .padding(.leading, .spacingXL)
            
            VStack {
              Button {
                viewStore.send(.presentLogoutPopup)
              } label: {
                Text("로그아웃")
                  .font(.body1)
                  .foregroundColor(.black900)
                  .padding([.top, .bottom], .spacingS)
                  .padding([.leading, .trailing], .spacingXL)
                Spacer()
              }
              .frame(height: 48)
              
              Button {
                viewStore.send(.presentWithdrawalPopup)
              } label: {
                Text("탈퇴하기")
                  .font(.body1)
                  .foregroundColor(.black900)
                  .padding([.top, .bottom], .spacingS)
                  .padding([.leading, .trailing], .spacingXL)
                Spacer()
              }
              .frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white50)
            
            Rectangle().fill(Color.white)
              .frame(height: 56)
            
            Text("위치 정보 설정")
              .font(.subtitle4)
              .foregroundColor(.black800)
              .padding(.leading, .spacingXL)
            
            VStack {
              Button {
                viewStore.send(.moveToSetting)
              } label: {
                HStack {
                  Text("위지 정보 설정 바로가기")
                    .font(.body1)
                    .foregroundColor(.black900)
                    .padding([.top, .bottom], .spacingS)
                    .padding([.leading, .trailing], .spacingXL)
                  Spacer()
                  Image("arrowForward")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 24)
                }
              }
              .frame(height: 48)
              .background(Color.white50)
              
              Text(
                  """
                  위치 정보 수집을 동의하시면 회원님의 위치정보를 이용해
                  지도 상에서 주변 채팅방을 표시합니다. 지도 상의 위치 정보는
                  채팅방 참여 인원수를 표기할 때 활용되며 다른사람들에게
                  자신의 위치가 노출 될 수 있습니다. 또한, 채팅방 내에서
                  다른 회원들에게 현재 장소 반경 내 위치 여부를  표시하는데
                  사용됩니다. 위치 정보 사용 동의는 언제든지 변경할 수 있습니다.
                  """
              )
                .lineLimit(nil)
                .font(.body4)
                .padding(.top, 8)
                .padding(.leading, 24)
                .hLeading()
                .foregroundColor(.white800)
                .background(.white)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
          }
        }
        .background(Color.white)
        
        .ttPopup(
          isShowing: viewStore.binding(
            get: \.popupPresented,
            send: MyInfoAction.dismissPopup
          ),
          topImageString: viewStore.popupType == .logout ? "logout_g" : "withdrawal_g") {
            TTPopupView.init(
              popUpCase: viewStore.popupType == .logout ? .oneLineTwoButton : .twoLineOneButton,
              title: viewStore.popupType == .logout ? "로그아웃 하시겠어요?" : "정말 티키타카를 탈퇴하시겠어요?",
              subtitle: viewStore.popupType == .logout ? "" : "탈퇴하면 회원정보와 앱 활동 내역이 모두 삭제돼요.",
              leftButtonName: "취소",
              rightButtonName: viewStore.popupType == .logout ? "로그아웃" : "탈퇴하기",
              confirm: {
                viewStore.send(
                  viewStore.popupType == .logout ?
                  MyInfoAction.logoutAction : MyInfoAction.withDrawalAction)
              },
              cancel: {
                viewStore.send(.dismissPopup)
              }
            )
          }
          .onChange(of: viewStore.isDismissCurrentView) { isDismissCurrentView in
            if isDismissCurrentView {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
          .onDisappear {
            viewStore.send(.movingAction(viewStore.dismissType))
          }
      }
    }
  }
}

struct MyInfoRow: View {
  var title: String
  var description: String
  
  var body: some View {
    VStack {
    HStack {
      Text(title)
        .font(.body1)
        .foregroundColor(.white800)
      
      Text(description)
        .font(.body1)
        .foregroundColor(.black900)
      
      Spacer()
    }
    .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
    }
    .frame(height: 48)
  }
}

struct MyInfoView_Previews: PreviewProvider {
  static var previews: some View {
    MyInfoView(store: .init(
      initialState: MyInfoState(),
      reducer: myInfoReducer,
      environment: MyInfoEnvironment()
      )
    )
  }
}
