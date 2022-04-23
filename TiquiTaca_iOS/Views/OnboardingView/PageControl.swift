//
//  PageControl.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI


struct PageControl: UIViewRepresentable {
	var numberOfPages: Int
	@Binding var currentPage: Int

	func makeUIView(context: Context) -> UIPageControl {
		let control = UIPageControl()
		control.numberOfPages = numberOfPages
		control.currentPageIndicatorTintColor = .darkGray
		control.pageIndicatorTintColor = .lightGray

		return control
	}

	func updateUIView(_ uiView: UIPageControl, context: Context) {
		uiView.currentPage = currentPage
	}
}
