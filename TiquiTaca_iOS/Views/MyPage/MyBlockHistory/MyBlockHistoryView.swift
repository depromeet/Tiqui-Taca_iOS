//
//  MyBlockHistoryView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import SwiftUI
import ComposableArchitecture

struct MyBlockHistoryView: View {
  let store: Store<MyBlockHistoryState, MyBlockHistoryAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Text("차단 이력")
          Spacer()
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image("idelete")
          }
        }
        .padding(EdgeInsets(top: 28, leading: .spacing24, bottom: 22, trailing: .spacing24))
        
        Text("상대방을 차단하면 상대방의 활동 뿐만 아니라,\n회원님의 활동도 상대방에게 더 이상 보이지 않게 됩니다.")
          .padding([.leading, .trailing], .spacing24)
        
        Text("차단한 유저")
          .padding(EdgeInsets(top: 28, leading: .spacing24, bottom: 0, trailing: .spacing24))
        
        BlockListView(store: store.scope(
          state: \.blockListView,
          action: MyBlockHistoryAction.blockListView
        ))
        Spacer()
      }
    }
  }
}

struct MyBlockHistoryView_Previews: PreviewProvider {
  static var previews: some View {
    MyBlockHistoryView(store: .init(
      initialState: MyBlockHistoryState(),
      reducer: myBlockHistoryReducer,
      environment: MyBlockHistoryEnvironment())
    )
  }
}
