//
//  ChatMenuView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ChatMenuView: View {
  typealias State = ChatMenuState
  typealias Action = ChatMenuAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let roomName: String
    let participantCount: Int
    let participantList: [UserEntity.Response]
    let questionCount: Int
    let questionList: [QuestionEntity.Response]
    
    init(state: State) {
      roomName = state.roomName
      participantCount = state.participantCount
      participantList = state.participantList
      questionCount = state.questionCount
      questionList = state.questionList
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore.init(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      topNavigationView
      
      VStack(alignment: .leading) {
        if viewStore.questionList.isEmpty {
          VStack(alignment: .center) {
            Image("bxNoAnswer")
              .resizable()
              .frame(width: 108, height: 108)
              .padding(16)
            Text("아직 사용자들이 남긴 질문이 없어요!\n처음으로 질문을 남겨보세요!")
              .font(.body2)
              .foregroundColor(.white900)
          }
          .frame(maxWidth: .infinity, maxHeight: 336)
        } else {
          Text("최근 등록된 질문")
            .font(.heading3)
            .foregroundColor(.black800)
          Text("총 \(viewStore.questionCount)개의 질문")
            .font(.body7)
            .foregroundColor(.black100)
          
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
        Button {
          viewStore.send(.clickQuestionAll)
        } label: {
          Text("질문 전체보기")
        }
        .buttonStyle(TTButtonLargeBlackStyle())
      }
      .padding(15)
      VStack {
      }
      .frame(maxWidth: .infinity, maxHeight: 8)
      .background(Color.white50)
      
      VStack(alignment: .leading) {
        Text("현재 티키타카 중인 사람들")
          .font(.heading3)
          .foregroundColor(.black800)
        
        Text("총 \(viewStore.participantCount)명의 참여자")
          .font(.body7)
          .foregroundColor(.black100)
          List {
            ForEach(viewStore.participantList) { participant in
              HStack {
                ForEach(0..<4) { row in
                  VStack(alignment: .center) {
                    Image(participant.profile.imageName)
                      .resizable()
                      .frame(width: 64, height: 64)

                    Text(participant.nickname)
                      .font(.body3)
                      .foregroundColor(.black100)
                  }
                }
                .frame(maxWidth: .infinity)
              }
              .listRowSeparator(.hidden)
            }
          }
          .listStyle(.plain)
      }
      .padding(16)
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
        
        Text(viewStore.roomName)
          .foregroundColor(Color.white)
        Text("+ \(viewStore.participantCount)")
          .foregroundColor(Color.white)
        
        Spacer()
        
        Button {
          viewStore.send(.roomExit)
        } label: {
          Image("chat_exit")
        }
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.black800)
    .frame(height: 88)
  }
}

struct ChatMenuView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMenuView(
      store: .init(
        initialState: ChatMenuState(),
        reducer: chatMenuReducer,
        environment: ChatMenuEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
