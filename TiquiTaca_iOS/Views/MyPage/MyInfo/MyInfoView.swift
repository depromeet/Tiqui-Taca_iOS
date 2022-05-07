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
    NavigationView {
      WithViewStore(self.store) { viewStore in
        VStack(alignment: .leading, spacing: .spacing12) {
          HStack {
            Text("내 정보")
              .font(.H1)
              .foregroundColor(.black800)
            
            Spacer()
            
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image("idelete")
            }
          }
          .padding(EdgeInsets(top: 28, leading: .spacing24, bottom: 22, trailing: .spacing24))
          
          Text("회원 정보")
            .font(.Subtitle4)
            .foregroundColor(.black800)
            .padding(.leading, .spacing24)
          
          VStack(alignment: .leading, spacing: .spacing12) {
            MyInfoRow(
              title: "닉네임",
              description: viewStore.nickName,
              buttonVisible: true
            )
            MyInfoRow(
              title: "휴대폰 번호",
              description: viewStore.phoneNumber)
            
            MyInfoRow(
              title: "최초 가입일",
              description: viewStore.createdAt
            )
          }
          .background(Color.white50)
          
          
          Text("로그인 관리")
            .font(.Subtitle4)
            .foregroundColor(.black800)
            .padding(.leading, .spacing24)
          
          VStack(alignment: .leading) {
            Button {
              viewStore.send(.logoutAction)
            } label: {
              Text("로그아웃")
                .font(.B1)
                .foregroundColor(.black900)
            }
            .padding(EdgeInsets(top: .spacing12, leading: .spacing24, bottom: .spacing12, trailing: .spacing24))
            
            Button {
              viewStore.send(.withDrawalAction)
            } label: {
              Text("탈퇴하기")
                .font(.B1)
                .foregroundColor(.black900)
            }
            .padding(EdgeInsets(top: .spacing12, leading: .spacing24, bottom: .spacing12, trailing: .spacing24))
          }
          .frame(maxWidth: .infinity)
          .background(Color.white50)
          
          Spacer()
        }
      }
    }
  }
}

struct MyInfoRow: View {
  var title: String
  var description: String
  var buttonVisible: Bool = false
  @State var buttonPressed = false
  
  var body: some View {
    HStack {
      Text(title)
        .font(.B1)
        .foregroundColor(.white800)
      
      Text(description)
        .font(.B1)
        .foregroundColor(.black900)
      
      Spacer()
      Button {
        $buttonPressed
      } label: {
        Text(buttonPressed ? "완료" : "변경")
          .font(.Subtitle3)
          .foregroundColor(.blue800)
      }
      .opacity(buttonVisible ? 1 : 0)
    }
    .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
  }
}

struct MyInfoView_Previews: PreviewProvider {
  static var previews: some View {
    MyInfoView(store: .init(
      initialState: MyInfoState(),
      reducer: myInfoReducer,
      environment: MyInfoEnvironment())
    )
  }
}
