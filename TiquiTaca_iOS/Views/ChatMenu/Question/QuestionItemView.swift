//
//  QuestionItemView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct QuestionItemView: View {
  typealias State = QuestionItemState
  typealias Action = QuestionItemAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    var id: String
    var user: UserEntity.Response?
    var content: String
    var commentList: [CommentEntity]
    var createdAt: Date
    var likesCount: Int
    var commentsCount: Int
    var ilike: Bool
    
    init(state: State) {
      id = state.id
      user = state.user
      content = state.content
      commentList = state.commentList
      createdAt = state.createdAt
      likesCount = state.likesCount
      commentsCount = state.commentsCount
      ilike = state.ilike
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image(viewStore.user?.profile.imageName ?? "defaultProfile")
          .resizable()
          .frame(width: 32, height: 32)
        
        VStack(alignment: .leading) {
          Text(viewStore.user?.nickname ?? "")
            .font(.body4)
            .foregroundColor(.black900)
          Text("1시간 전")
            .font(.body8)
            .foregroundColor(.white800)
        }
        
        Spacer()
        Image("arrowForward")
          .resizable()
          .frame(width: 24, height: 24)
      }
      
      VStack {
        Text(viewStore.content)
          .font(.body3)
          .foregroundColor(.black900)
        HStack {
          Button {
            viewStore.send(.likeClickAction)
          } label: {
            Image(viewStore.ilike ? "reply_good_on" : "reply_good_off")
            Text("\(viewStore.likesCount)")
              .font(.body7)
              .foregroundColor(.white800)
          }
          
          Image("comments")
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(viewStore.commentsCount)")
            .font(.body7)
            .foregroundColor(.white800)
        }
      }
    }
    .padding(.top, 10)
    .padding([.leading, .trailing], 12)
    .padding(.bottom, 16)
    .background(Color.white100)
    .cornerRadius(14)
  }
}

struct QuestionItemView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionItemView(
      store: .init(
        initialState: QuestionItemState(),
        reducer: questionItemReducer,
        environment: QuestionItemEnvironment(
          appService: AppService(),
          mainQueue: .main
        )
      )
    )
  }
}
