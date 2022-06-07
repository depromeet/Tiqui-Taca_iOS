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
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  struct ViewState: Equatable {
    let route: State.Route?
    let questionList: [QuestionEntity.Response]
    let sortType: QuestionSortType
    let bottomSheetPosition: TTBottomSheet.Position
    
    init(state: State) {
      route = state.route
      questionList = state.questionList
      sortType = state.sortType
      bottomSheetPosition = state.bottomSheetPosition
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
          ForEach(viewStore.questionList) { question in
            Button {
              viewStore.send(.selectQuestionDetail(question.id))
            } label: {
              QuestionItemView(model: question)
            }
            .listRowBackground(Color.white)
            .listRowSeparator(.hidden)
          }
          .background(Color.white)
        }
        .listStyle(.plain)
      }
      
      Spacer()
      NavigationLink(
        tag: State.Route.questionDetail,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          QuestionDetailView(
            store: store.scope(
              state: \.questionDetailViewState,
              action: QuestionListAction.questionDetailView
            )
          )
        },
        label: EmptyView.init
      )
    }
    .bottomSheet(
      bottomSheetPosition: viewStore.binding(
        get: \.bottomSheetPosition,
        send: Action.setBottomSheetPosition
      ),
      options: TTBottomSheet.Options
    ) {
      VStack {
        Text("필터")
          .font(.body2)
          .foregroundColor(.black100)
          .hCenter()
          .frame(height: 10)
          .padding(12)
        
        Rectangle().fill(Color.black600)
          .frame(height: 1)
          .hCenter()
        
        Button {
          viewStore.send(.selectSortType(.neworder))
        } label: {
          Text("모든 질문")
            .hCenter()
            .font(.subtitle2)
            .foregroundColor(.white)
        }
        .frame(height: 54)
        
        Rectangle().fill(Color.black600)
          .frame(height: 1)
          .hCenter()
        
        Button {
          viewStore.send(.selectSortType(.notanswered))
        } label: {
          Text("미답변")
            .hCenter()
            .font(.subtitle2)
            .foregroundColor(.white)
        }
        .frame(height: 54)
        
        Rectangle().fill(Color.black600)
          .frame(height: 1)
          .hCenter()
        
        Button {
          viewStore.send(.selectSortType(.oldorder))
        } label: {
          Text("오래된 순")
            .hCenter()
            .font(.subtitle2)
            .foregroundColor(.white)
        }
        .frame(height: 54)
        Spacer()
      }
      .vCenter()
      .hCenter()
    }
    .background(Color.white)
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
    .ignoresSafeArea()
    .onAppear {
      viewStore.send(.getQuestionListByType)
    }
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          self.presentationMode.wrappedValue.dismiss()
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
//          viewStore.send(.selectSortType)
          viewStore.send(.setBottomSheetPosition(.middle))
        } label: {
          HStack {
            Text(viewStore.sortType.title)
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
