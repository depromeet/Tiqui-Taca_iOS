//
//  BlockListView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct BlockListView: View {
  let store: Store<BlockListState, BlockListAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        ForEach(viewStore.blockUsers) { blockUser in
          HStack {
            Text(blockUser.nickName)
              .font(.B1)
              .foregroundColor(.black900)
            
            Spacer()
            
            Button {
              viewStore.send(
                .selectDetail(blockUser.userId)
              )
            } label: {
              Text("차단 해제")
                .font(.B7)
                .foregroundColor(.white800)
            }
            .sheet(
              isPresented: viewStore.binding(
                get: \.isPopupPresented,
                send: BlockListAction.dismissBlockDetail
              )
            ) {
              WebView(url: URL(string: "https://www.naver.com"))
            }
          }
          .padding(EdgeInsets(top: .spacing12, leading: .spacing24, bottom: .spacing12, trailing: .spacing24))
        }
        .background(Color.white50)
      }
    }
  }
}

struct BlockListView_Previews: PreviewProvider {
  static var previews: some View {
    BlockListView(store: .init(
      initialState: BlockListState(
        blockUsers: [
          BlockUser(userId: "hk", nickName: "gkrod", profile: "3"),
          BlockUser(userId: "rokwon", nickName: "rokwon", profile: "4")
        ]
      ),
      reducer: blockListReducer,
      environment: BlockListEnvironment())
    )
  }
}
