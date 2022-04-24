//
//  MyPageView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
	let store: Store<MyPageState, MyPageAction>
	
	var body: some View {
		WithViewStore(self.store) { _ in
			Text("MyPageTab")
		}
	}
}

struct MyPageView_Previews: PreviewProvider {
	static var previews: some View {
		MyPageView(store: .init(
			initialState: MyPageState(),
			reducer: myPageReducer,
			environment: MyPageEnvironment())
		)
	}
}
