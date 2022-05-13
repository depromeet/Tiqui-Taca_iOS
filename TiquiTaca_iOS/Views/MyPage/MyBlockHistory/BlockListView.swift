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
      ZStack {
        VStack(spacing: 0) {
          ForEach(viewStore.blockUsers, id: \.id) { blockUser in
            HStack {
              Text(blockUser.nickname)
                .font(.body1)
                .foregroundColor(.black900)
              
              Spacer()
              
              Button {
                viewStore.send(
                  .selectUnblockUser(blockUser)
                )
              } label: {
                Text("차단 해제")
                  .font(.body7)
                  .foregroundColor(.white800)
              }
            }
            .padding(EdgeInsets(top: .spacingS, leading: .spacingXL, bottom: .spacingS, trailing: .spacingXL))
          }
          .background(Color.white50)
        }
      }
    }
  }
}

struct BlockListView_Previews: PreviewProvider {
  static var previews: some View {
    BlockListView(store: .init(
      initialState: BlockListState(
        blockUsers: [
//          BlockUser(userId: "hk", nickName: "gkrod", profile: "3"),
//          BlockUser(userId: "rokwon", nickName: "rokwon", profile: "4")
        ]
      ),
      reducer: blockListReducer,
      environment: BlockListEnvironment())
    )
  }
}
