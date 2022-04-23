//
//  SplashView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI

struct SplashView: View {
	@State var canMove = false
	let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
	
	var body: some View {
		NavigationView {
			VStack {
				Text("Tiqui\nTaca")
					.font(.largeTitle)
					.fontWeight(.bold)
					.vCenter()
			}
			.padding([.bottom], 128)
			.navigationBarHidden(true)
			
			// 로그인 확인, accessToken, refreshToken 리로드
//			NavigationLink(
//				destination: OnboardingView(),
//				isActive: self.$canMove
//			) { EmptyView() }
//			.isDetailLink(false)
		}
	}
}

struct SplashView_Previews: PreviewProvider {
	static var previews: some View {
		SplashView()
	}
}
