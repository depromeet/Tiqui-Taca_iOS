//
//  MsgAndNotiView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MsgAndNotiView: View {
	let store: Store<MsgAndNotiState, MsgAndNotiAction>
	
	var body: some View {
		WithViewStore(self.store) { _ in
			Text("MsgAndNotiTab")
		}
	}
}

struct MsgAndNotiView_Previews: PreviewProvider {
	static var previews: some View {
		MsgAndNotiView(store: .init(
			initialState: MsgAndNotiState(),
			reducer: msgAndNotiReducer,
			environment: MsgAndNotiEnvironment())
		)
	}
}
