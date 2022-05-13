//
//  PageControl.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
	var numberOfPages: Int
	@Binding var currentPage: Int

	func makeUIView(context: Context) -> UIPageControl {
		let control = UIPageControl()
		control.numberOfPages = numberOfPages
    control.currentPageIndicatorTintColor = Color.green700.uiColor
		control.pageIndicatorTintColor = Color.black100.uiColor
		control.isUserInteractionEnabled = false
		control.currentPage = currentPage
		return control
	}

	func updateUIView(_ uiView: UIPageControl, context: Context) {
		uiView.currentPage = currentPage
	}
}
