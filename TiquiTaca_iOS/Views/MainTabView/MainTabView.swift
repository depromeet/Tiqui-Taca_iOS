//
//  TabView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/23.
//

import SwiftUI

struct MainTabView: View {
	var body: some View {
		TabView {
			MapTabView()
			ChatTabView()
			NotiTabView()
			MyPageTabView()
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
	}
}


private struct MapTabView: View {
	var body: some View {
		Text("Map")
			.tabItem {
				Image(systemName: "square.fill")
					.font(.title)
				Text("지도")
			}
	}
}


private struct ChatTabView: View {
	var body: some View {
		Text("Chat")
			.tabItem {
				Image(systemName: "square.fill")
					.font(.title)
				Text("채팅")
			}
	}
}

private struct NotiTabView: View {
	var body: some View {
		Text("Noti")
			.tabItem {
				Image(systemName: "square.fill")
					.font(.title)
				Text("쪽지 알림")
			}
	}
}

private struct MyPageTabView: View {
	var body: some View {
		Text("마이페이지")
			.tabItem {
				Image(systemName: "square.fill")
					.font(.title)
				Text("마이페이지")
			}
	}
}
