//
//  OnboardingView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
	let store: Store<OnboardingState, OnboardingAction>
	
	var body: some View {
		WithViewStore(self.store) { viewStore in
			VStack(alignment: .center, spacing: 8) {
				VStack {
					PageControl(
						numberOfPages: 3,
						currentPage: viewStore.binding(
							get: \.currentPage, send: OnboardingAction.pageControlTapped
						)
					)
					
					Text("Welcome Tiki Taka")
						.font(.system(size: 24))
						.fontWeight(.semibold)
					Text("Hello, Welcome!\nEnjoy Enjoy Enjoy")
						.font(.system(size: 14))
						.multilineTextAlignment(.center)
						.frame(alignment: .center)
						.padding(.vertical, 8)
					
					TabView(
						selection: viewStore.binding(
							get: \.currentPage,
							send: OnboardingAction.onboardingPageSwipe
					)) {
						Image(systemName: "d.square.fill")
							.resizable()
							.frame(width: 100, height: 100)
							.tag(0)
						Image(systemName: "p.square.fill")
							.resizable()
							.frame(width: 100, height: 100)
							.tag(1)
						Image(systemName: "m.square.fill")
							.resizable()
							.frame(width: 100, height: 100)
							.tag(2)
					}
						.tabViewStyle(.page(indexDisplayMode: .never))
						.frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
						.background(.white)
						.cornerRadius(16)
				}
				.vCenter()
				
				VStack(spacing: 24) {
					Button {
						// Move to login view
					} label: {
						Text("이미 계정이 있다면? ") + Text("로그인").fontWeight(.heavy)
					}
					.foregroundColor(.gray)
						
					Button("시작하기") { }
						.frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
						.foregroundColor(.white)
						.background(.black)
						.cornerRadius(16)
				}
				.padding(.horizontal, 16)
			}
			.padding(.bottom, 24)
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(store: .init(
			initialState: OnboardingState(currentPage: 0),
			reducer: onBoardingReducer,
			environment: OnboardingEnvironment()
		))
	}
}