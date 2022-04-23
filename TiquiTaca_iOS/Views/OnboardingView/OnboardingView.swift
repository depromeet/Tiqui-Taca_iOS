//
//  OnboardingView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI

struct OnboardingView: View {
	@State var currentPage = 0
	var body: some View {
		VStack(alignment: .center, spacing: 8) {
			VStack {
				PageControl(numberOfPages: 3, currentPage: $currentPage)
				
				Text("온보딩 타이틀")
					.font(.system(size: 24))
					.fontWeight(.semibold)
				
				Text("서브 타이틀이구여\n서브타이틀이지요")
					.font(.system(size: 14))
					.fontWeight(.regular)
					.padding(.vertical, 8)
				
				HStack {
				}
				.frame(width: 300, height: 300, alignment: .center)
				.background(.gray)
				.cornerRadius(16)
			}.vCenter()
			
			
			VStack(spacing: 24) {
				Button("이미 계정이 있다면? 로그인"){ }
					.foregroundColor(.gray)
				
				Button("시작하기") { }
					.frame(maxWidth: .infinity, maxHeight: 56)
					.cornerRadius(16)
					.foregroundColor(.white)
					.background(.gray)
			}
		}
		.vBottom()
		.padding(10)
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView()
	}
}
