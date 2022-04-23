//
//  TiquiTaca_iOSApp.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/02.
//

import SwiftUI

@main
struct TiquiTaca: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
			OnboardingView(store: .init(
				initialState: OnboardingState(currentPage: 0),
				reducer: onBoardingReducer,
				environment: OnboardingEnvironment()
			))
				
      // MainTabView()
    }
  }
}
