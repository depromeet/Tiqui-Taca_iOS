//
//  QuestionView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct QuestionListView: View {
  typealias State = QuestionListState
  typealias Action = QuestionListAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let questionList: [QuestionEntity.Response]
    let sortType: QuestionSortType
    
    init(state: State) {
      questionList = state.questionList
      sortType = state.sortType
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      topNavigationView
      
      if viewStore.questionList.isEmpty {
        VStack(alignment: .center) {
          Image("bxNoAnswer")
            .resizable()
            .frame(width: 160, height: 160)
            .padding(.spacingM)
          Text("아직 사용자들이 남긴 질문이 없어요!\n처음으로 질문을 남겨보세요!")
            .font(.body2)
            .foregroundColor(.white900)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        List {
          ForEach(viewStore.questionList.prefix(2)) { question in
            QuestionItemView(
              store: .init(
                initialState: QuestionItemState(
                  id: question.id,
                  user: question.user,
                  content: question.content,
                  commentList: question.commentList,
                  createdAt: question.createdAt,
                  likesCount: question.likesCount,
                  commentsCount: question.commentsCount,
                  ilike: question.ilike
                ),
                reducer: questionItemReducer,
                environment: QuestionItemEnvironment(
                  appService: AppService(),
                  mainQueue: .main
                )
              )
            )
          }
          .onTapGesture {
            viewStore.send(.selectQuestionDetail)
          }
        }
      }
      
      Spacer()
    }
    .background(Color.white)
    .ignoresSafeArea()
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          viewStore.send(.backButtonAction)
        } label: {
          Image("chat_backButton")
        }
        
        Text("모든 질문")
          .foregroundColor(Color.white)
        
        Spacer()
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
      
      HStack {
        VStack(alignment: .leading) {
          Text("이거 궁금해요!")
            .font(.heading2)
            .foregroundColor(.white)
          
          Text("총 \(viewStore.questionList.count)개의 질문")
            .font(.body7)
            .foregroundColor(.white900)
        }
        
        Spacer()
        
        Button {
          viewStore.send(.selectSortType)
        } label: {
          HStack {
            Text("오래된 순")
              .font(.cap2)
              .foregroundColor(.white)
            
            Image("arrowDownWhite")
          }
        }
        .padding([.top, .bottom], 4)
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .overlay(
          RoundedRectangle(cornerRadius: 30)
            .stroke(Color.green600, lineWidth: 1)
        )
      }
      .padding(16)
    }
    .background(Color.black800)
    .frame(height: 152)
  }
}

struct QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionListView(
      store: .init(
        initialState: QuestionListState(),
        reducer: questionListReducer,
        environment:
          QuestionListEnvironment(
            appService: AppService(),
            mainQueue: .main
          )
      )
    )
  }
}
