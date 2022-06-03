//
//  QuestionDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct QuestionDetailView: View {
  typealias State = QuestionDetailState
  typealias Action = QuestionDetailAction
  
  let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
 
  struct ViewState: Equatable {
    let question: QuestionEntity.Response?
    let likesCount: Int
    let likeActivated: Bool
    let commentCount: Int
    
    init(state: State) {
      question = state.question
      likesCount = state.likesCount
      likeActivated = state.likeActivated
      commentCount = state.commentCount
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      topNavigationView
      
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Image(viewStore.question?.user?.profile.imageName ?? "defaultProfile")
            .resizable()
            .frame(width: 32, height: 32)
          
          VStack(alignment: .leading) {
            Text(viewStore.question?.user?.nickname ?? "")
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
        
        VStack {
          Text(viewStore.question?.content ?? "")
            .font(.body3)
            .foregroundColor(.black900)
          HStack {
            Button {
              viewStore.send(.likeClickAction)
            } label: {
              Image(viewStore.likeActivated ? "replyGoodOn" : "replyGoodOff")
              Text("\(viewStore.likesCount)")
                .font(.body7)
                .foregroundColor(.white800)
            }
            
            Image("comments")
              .resizable()
              .frame(width: 20, height: 20)
            Text("\(viewStore.question?.commentsCount ?? 0)")
              .font(.body7)
              .foregroundColor(.white800)
          }
        }
      }
      .padding([.leading, .trailing], 20)
      .padding(.top, 24)
      .padding(.bottom, 18)
      
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 8)
        .background(Color.white100)
      
      if let commentList = viewStore.question?.commentList, !commentList.isEmpty {
        Text("댓글 \(viewStore.question?.commentList.count ?? 0)")
          .font(.subtitle1)
          .foregroundColor(.black800)
          .padding(.leading, 20)
          .padding(.top, 12)
        
        List {
          ForEach(viewStore.question?.commentList ?? []) { comment in
            
          }
          .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
      } else {
        VStack(alignment: .center) {
          Image("bxPancil")
            .resizable()
            .frame(width: 160, height: 160)
            .padding(.spacingM)
          Text("아직 사용자들이 남긴 답변이 없어요!\n처음으로 질문에 답변해보세요!")
            .font(.body2)
            .foregroundColor(.white900)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationBarHidden(true)
    .background(Color.white)
    .ignoresSafeArea()
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          self.presentationMode.wrappedValue.dismiss()
        } label: {
          Image("chat_backButton")
        }
        
        Text(viewStore.question?.user?.nickname ?? "")
          .font(.subtitle2)
          .foregroundColor(.white)
        
        Text("님의 질문")
          .font(.subtitle2)
          .foregroundColor(.black200)
        
        Spacer()
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.black800)
    .frame(height: 88)
  }
}

struct QuestionDetailView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionDetailView(
      store: .init(
        initialState: QuestionDetailState(),
        reducer: questionDetailReducer,
        environment:
          QuestionDetailEnvironment(
            appService: AppService(),
            mainQueue: .main
          )
      )
    )
  }
}
