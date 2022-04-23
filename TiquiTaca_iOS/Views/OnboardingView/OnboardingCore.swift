//
//  OnboardingCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import Foundation
import ComposableArchitecture

struct OnboardingState: Equatable {
	var currentPage: Int
}

enum OnboardingAction: Equatable {
	case pageControlTapped(Int)
	case onboardingPageSwipe(Int)
}

struct OnboardingEnvironment { }

let onBoardingReducer = Reducer<
	OnboardingState,
	OnboardingAction,
	OnboardingEnvironment
> { state, action, _ in
	switch action {
	case .onboardingPageSwipe(let page):
		print("page값", page)
		state.currentPage = page
		return .none
	case .pageControlTapped(let page):
		print("값page", page)
		state.currentPage = page
		return .none
	}
}
