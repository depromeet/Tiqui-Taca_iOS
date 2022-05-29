//
//  ChatLogView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//

import SwiftUI

struct ChatLogView: View {
	let chatLogList: [ChatLogEntity.Response]
	
	var body: some View {
		Text("Hello, World!")
	}
}

struct ChatLogView_Previews: PreviewProvider {
	static var previews: some View {
		ChatLogView(chatLogList: [])
	}
}