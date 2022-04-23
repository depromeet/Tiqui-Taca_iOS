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
	case swipeOnboarding(Int)
}

struct OnboardingEnvironment { }

let onBoardingReducer = Reducer<
	OnboardingState,
	OnboardingAction,
	OnboardingEnvironment
> { _, action, _ in
	switch action {
	case .swipeOnboarding(let page):
		return .none
	}
}
