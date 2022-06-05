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
  let viewStore: ViewStore<ViewState, Action>
  
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
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image(viewStore.comment?.user?.profile.imageName ?? "defaultProfile")
          .resizable()
          .frame(width: 32, height: 32)
        
        VStack(alignment: .leading) {
          Text(viewStore.comment?.user?.nickname ?? "")
            .font(.body4)
            .foregroundColor(.black900)
          Text("1시간 전")
            .font(.body8)
            .foregroundColor(.white800)
        }
        
        Spacer()
        Button {
          viewStore.send(.moreClickAction)
        } label: {
          Image("moreVertical")
        }
      }
      
      Text(viewStore.comment?.comment ?? "")
        .font(.body3)
        .foregroundColor(.black900)
    }
    .padding(.top, 10)
    .padding([.leading, .trailing], 12)
    .padding(.bottom, 16)
    .background(Color.white)
    .cornerRadius(14)
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
                appService: AppService(),
                mainQueue: .main
              )
          )
    )
  }
}
