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
      Color.black800.opacity(0.7)
      
      VStack(alignment: .center, spacing: 0) {
        VStack(spacing: .spacingS) {
          ChatGuidePageView(currentPage: $currentPage)
            .frame(maxWidth: .infinity, maxHeight: 440)
          PageControl(numberOfPages: 3, currentPage: $currentPage)
            .padding(.bottom, 8)
        }
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
        Text(
          """
          욕설, 음란행위와 같은 사용자에게
          불쾌감을 줄 수 있는 행위들은 서비스
          정책에 의거하여 정지처리 될 수 있으니
          유의하여 주시길 바랍니다.
          """ )
          .font(.body3)
          .lineSpacing(8)
          .multilineTextAlignment(.center)
      }
      .tag(0)
      
      LazyVStack(spacing: .spacingXS) {
        Image("chatGuide2")
        Text("장소 카테고리별 특색있는 대화를")
          .font(.heading1)
        Text("대학교, 공연장, 한강공원 등 카테고리별 장소에 따라\n일어나는 일들을 실시간으로 공유해요!")
          .font(.body3)
      }
      .tag(1)
      
      LazyVStack(spacing: .spacingXS) {
        Image("chatGuide3")
        Text("다양한 방법으로 나눠보세요")
          .font(.heading1)
        Text("장소에 대한 궁금증이나, 후기 등 나누고 싶은 이야기를\n질문하기, 채팅 및 쪽지로 공유해보세요!")
          .font(.body3)
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
