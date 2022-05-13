//
//  MyBlockHistoryView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/06.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct MyBlockHistoryView: View {
  let store: Store<MyBlockHistoryState, MyBlockHistoryAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        VStack(alignment: .leading) {
          HStack {
            Text("차단 이력")
              .font(.heading1)
              .foregroundColor(.black800)
            
            Spacer()
            
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image("idelete")
            }
          }
          .padding(EdgeInsets(top: 28, leading: .spacingXL, bottom: 22, trailing: .spacingXL))
          
          Text("상대방을 차단하면 상대방의 활동 뿐만 아니라,\n회원님의 활동도 상대방에게 더 이상 보이지 않게 됩니다.")
            .font(.body2)
            .foregroundColor(.white800)
            .padding([.leading, .trailing], .spacingXL)
          
          Text("차단한 유저")
            .font(.subtitle4)
            .foregroundColor(.black800)
            .padding(EdgeInsets(top: 28, leading: .spacingXL, bottom: 0, trailing: .spacingXL))
          
          BlockListView(store: store.scope(
            state: \.blockListView,
            action: MyBlockHistoryAction.blockListView
          ))
          
          
          Spacer()
        }
        TTPopupView.init(
          popUpCase: .twoLineTwoButton,
          title: "'\(viewStore.unBlockUser?.nickname ?? "")' 님을 차단 해제하시겠어요?",
          subtitle: "차단 해제할 경우 상대방이 보낸\n대화를 볼 수 있고 쪽지를 전송할 수 있어요.",
          leftButtonName: "취소",
          rightButtonName: "해제하기",
          confirm: {
            viewStore.send(.unblockUser(viewStore.unBlockUser?.id ?? ""))
          },
          cancel: {
            viewStore.send(.dismissPopup)
          }
        )
        .opacity(viewStore.popupPresented ? 1 : 0)
      }
      .onAppear(
        perform: {
          viewStore.send(.getBlockUserList)
        })
    }
  }
}

struct MyBlockHistoryView_Previews: PreviewProvider {
  static var previews: some View {
    MyBlockHistoryView(
      store: .init(
        initialState: MyBlockHistoryState(),
        reducer: myBlockHistoryReducer,
        environment: MyBlockHistoryEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
