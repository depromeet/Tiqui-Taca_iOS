//
//  OnboardingPageView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/02.
//

import SwiftUI

struct OnboardingPageView: View {
  @Binding var currentPage: Int
  
  var body: some View {
    TabView(selection: $currentPage) {
      LazyVStack(spacing: .spacingXS) {
        Text("실시간으로 위치에 있는 사람들과")
          .font(.heading1)
        Text("궁금한 장소에 있는 유저들과 익명으로\n자유롭게 이야기를 나눠보세요!")
          .font(.body3)
        Image("illustrationSection1")
      }
      .tag(0)
      
      LazyVStack(spacing: .spacingXS) {
        Text("장소 카테고리별 특색있는 대화를")
          .font(.heading1)
        Text("대학교, 공연장, 한강공원 등 카테고리별 장소에 따라\n일어나는 일들을 실시간으로 공유해요!")
          .font(.body3)
        Image("illustrationSection2")
      }
      .tag(1)
      
      LazyVStack(spacing: .spacingXS) {
        Text("다양한 방법으로 나눠보세요")
          .font(.heading1)
        Text("장소에 대한 궁금증이나, 후기 등 나누고 싶은 이야기를\n질문하기, 채팅 및 쪽지로 공유해보세요!")
          .font(.body3)
        Image("illustrationSection3")
      }
      .tag(2)
    }
    .foregroundColor(.white)
    .multilineTextAlignment(.center)
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}
