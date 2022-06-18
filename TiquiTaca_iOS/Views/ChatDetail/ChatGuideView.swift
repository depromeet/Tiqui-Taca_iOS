//
//  ChatGuideView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/18.
//

import SwiftUI
import TTDesignSystemModule

struct ChatGuideView: View {
  @State var currentPage: Int = 0
  @Binding var showGuideView: Bool

  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 0) {
        VStack(spacing: .spacingS) {
          ChatGuidePageView(currentPage: $currentPage)
            .frame(maxWidth: .infinity, maxHeight: 440)
          PageControl(numberOfPages: 3, currentPage: $currentPage)
            .padding(.bottom, 8)
        }
          .frame(height: 394)
          .background(Color.black800)
          .cornerRadius(30)
          .padding(.horizontal, 24)
        HStack {
          Button {
            UserDefaults.standard.setValue(true, forKey: "hideGuidView")
            showGuideView = false
          } label: {
            Text("다시 보지 않기")
              .font(.body3)
              .foregroundColor(.white600)
              .frame(width: (UIScreen.main.bounds.width - 48)/2 , height: 46)
          }
          
          VStack{}
            .frame(width: 1, height: 14)
            .background(Color.white600)
          
          Button {
            showGuideView = false
          } label: {
            Text("닫기")
              .font(.body3)
              .foregroundColor(.white600)
              .frame(width: (UIScreen.main.bounds.width - 48)/2, height: 46)
          }
        }
      }
      
    }
      .edgesIgnoringSafeArea(.all)
  }
}


struct ChatGuidePageView: View {
  @Binding var currentPage: Int
  
  var body: some View {
    TabView(selection: $currentPage) {
      LazyVStack(spacing: .spacingS) {
        Image("chatGuide1")
        Text("꼭 지켜주세요!")
          .font(.heading2)
          .foregroundColor(.white)
          .padding(.top, 8)
        Text(
          """
          욕설, 음란행위와 같은 사용자에게
          불쾌감을 줄 수 있는 행위들은 서비스
          정책에 의거하여 정지처리 될 수 있으니
          유의하여 주시길 바랍니다.
          """ )
          .font(.body3)
          .foregroundColor(.white800)
          .lineSpacing(4)
          .multilineTextAlignment(.center)
      }
      .tag(0)
      
      LazyVStack(spacing: .spacingS) {
        Image("chatGuide2")
        Text("현재 위치에서 채팅을 하면")
          .font(.heading2)
          .foregroundColor(.white)
          .padding(.top, 30)
        Text(
          """
          상대방 프로필이 깃발표시로 나타나
          지금 장소에 있는지 확인할 수 있어요.
          """ )
        .font(.body3)
        .foregroundColor(.white800)
        .lineSpacing(4)
        .multilineTextAlignment(.center)
      }
      .tag(1)
      
      LazyVStack(spacing: .spacingXS) {
        Image("chatGuide3")
        Text("내가 현재 위치에 있다면")
          .font(.heading2)
          .foregroundColor(.white)
          .padding(.top, 30)
        Text(
          """
          채팅방 이름 옆의 초록 불빛으로 내가
          현재 위치에서 참여 중인지 알 수 있어요.
          """ )
        .font(.body3)
        .foregroundColor(.white800)
        .lineSpacing(4)
        .multilineTextAlignment(.center)
      }
      .tag(2)
    }
    .foregroundColor(.white)
    .multilineTextAlignment(.center)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}


struct ChatGuideView_Previews: PreviewProvider {
  @State static var showGuideView: Bool = false
  static var previews: some View {
    ChatGuideView(showGuideView: $showGuideView)
  }
}
