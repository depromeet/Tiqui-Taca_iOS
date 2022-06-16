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
          
          VStack(alignment: .leading, spacing: .spacingS) {
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
              Spacer()
            }
            .padding(EdgeInsets(top: .spacingS, leading: .spacingXL, bottom: .spacingS, trailing: .spacingXL))
            
            Button {
              viewStore.send(.presentWithdrawalPopup)
            } label: {
              Text("탈퇴하기")
                .font(.body1)
                .foregroundColor(.black900)
              Spacer()
            }
            .padding(EdgeInsets(top: .spacingS, leading: .spacingXL, bottom: .spacingS, trailing: .spacingXL))
          }
          .frame(maxWidth: .infinity)
          .background(Color.white50)
          
          Spacer()
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
              subtitle: viewStore.popupType == .logout ? "" : "검토 후 2~3일 내 탈퇴처리 됩니다.",//"탈퇴하면 회원정보와 앱 활동 내역이 모두 삭제돼요.",
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
