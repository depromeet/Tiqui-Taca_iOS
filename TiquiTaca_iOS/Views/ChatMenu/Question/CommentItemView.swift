//
//  CommentItemView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct CommentItemView: View {
  typealias State = CommentItemState
  typealias Action = CommentItemAction
  
  let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let comment: CommentEntity?
    
    init(state: State) {
      comment = state.comment
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Image(viewStore.comment?.user?.profile.imageName ?? "defaultProfile")
            .resizable()
            .frame(width: 32, height: 32)
            .onTapGesture {
              viewStore.send(.profileSelected(viewStore.comment?.user))
            }
          
          VStack(alignment: .leading) {
            Text(
              viewStore.comment?.user?.status == UserStatus.forbidden ? "(이용제한 사용자)" : viewStore.comment?.user?.nickname ?? ""
            )
              .font(.body4)
              .foregroundColor(
                viewStore.comment?.user?.status == UserStatus.normal ? .black900 :.black50
              )
            Text(viewStore.comment?.createdAt.getTimeTodayOrDate() ?? "")
              .font(.body8)
              .foregroundColor(.white800)
          }
          
          Spacer()
          Button {
            viewStore.send(.moreClickAction(viewStore.comment?.id ?? "", viewStore.state.comment?.user?.id ?? ""))
          } label: {
            Image("moreVertical")
          }
          .buttonStyle(PlainButtonStyle())
        }
        
        Text(viewStore.comment?.comment ?? "")
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.leading)
          .font(.body3)
          .foregroundColor(.black900)
      }
      .background(Color.white)
      .padding(20)
      
      Rectangle().fill(Color.white100)
        .frame(height: 1)
    }
  }
}

struct CommentItemView_Previews: PreviewProvider {
  static var previews: some View {
    CommentItemView(
      store:
          .init(
            initialState: CommentItemState(),
            reducer: commentItemReducer,
            environment:
              CommentItemEnvironment(
//                appService: AppService(),
//                mainQueue: .main
              )
          )
    )
  }
}
