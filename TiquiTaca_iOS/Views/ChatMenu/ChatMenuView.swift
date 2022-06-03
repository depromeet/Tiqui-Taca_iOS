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
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  struct ViewState: Equatable {
    let route: State.Route?
    
    let roomInfo: RoomInfoEntity.Response?
    let roomUserList: [UserEntity.Response]
    let questionList: [QuestionEntity.Response]
    let unreadChatCount: Int?
    
    let popupPresented: Bool
    
    init(state: State) {
      route = state.route
      roomInfo = state.roomInfo
      roomUserList = state.roomUserList
      questionList = state.questionList
      unreadChatCount = state.unreadChatCount
      popupPresented = state.popupPresented
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
          Text("총 \(viewStore.questionList.count)개의 질문")
            .font(.body7)
            .foregroundColor(.black100)
          
          ForEach(viewStore.questionList) { question in
            Button {
              viewStore.send(.questionSelected(question.id))
            } label: {
              QuestionItemView(model: question)
            }
            
            NavigationLink(
              tag: State.Route.questionDetail,
              selection: viewStore.binding(
                get: ,
                send:
              ),
              destination: {
                QuestionDetailView(
                  store: store.scope(
                    state: <#T##(State) -> LocalState#>,
                    action: <#T##(LocalAction) -> Action#>
                  )
                )
              }
              label: EmptyView.init
            )
            
            NavigationLink(
              tag: State.Route.questionList,
              selection: viewStore.binding(
                get: ,
                send:
              ),
              destination: {
                QuestionListView(
                  store: store.scope(
                    state: <#T##(State) -> LocalState#>,
                    action: <#T##(LocalAction) -> Action#>
                  )
                )
              }
              label: EmptyView.init
            )
            
//            NavigationLink(
//              destination: {
//                QuestionDetailView(
//                  store: .init(
//                    initialState: QuestionDetailState(
//                      question: question,
//                      likesCount: question.likesCount,
//                      likeActivated: question.ilike,
//                      commentCount: question.commentsCount
//                    ),
//                    reducer: questionDetailReducer,
//                    environment: QuestionDetailEnvironment(
//                      appService: AppService(),
//                      mainQueue: .main
//                    )
//                  )
//                )
//              }, label: {
                
//              }
//            )
          }
        }
        
        NavigationLink(
          destination: {
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
          }, label: {
            Text("질문 전체보기")
//              .frame(maxWidth: .infinity, maxHeight: 56)
              .frame(maxWidth: .infinity, minHeight: 56)
              .foregroundColor(.white)
              .background(Color.black900)
              .cornerRadius(16)
              .overlay(
                RoundedRectangle(cornerRadius: 16)
                  .stroke(Color.black900, lineWidth: 1)
              )
              .font(.subtitle1)
          }
        )
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
        
        Text("총 \(viewStore.roomUserList.count)명의 참여자")
          .font(.body7)
          .foregroundColor(.black100)
        ScrollView {
          LazyVGrid(columns: colums, spacing: 20) {
            ForEach(viewStore.roomUserList) { participant in
              VStack(alignment: .center) {
                Image(participant.profile.imageName)
                  .resizable()
                  .frame(width: 64, height: 64)
                
                Text(participant.nickname)
                  .font(.body3)
                  .foregroundColor(.black100)
              }
            }
          }
        }
        .background(Color.white)
        .listStyle(.plain)
      }
      .background(Color.white)
      .padding(16)
    }
    .background(Color.white)
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
    .ignoresSafeArea()
    .onAppear {
//      viewStore.send(.getRoomInfo)
      viewStore.send(.getRoomUserListInfo)
      viewStore.send(.getQuestionList)
    }
    .ttPopup(
      isShowing: viewStore.binding(
        get: \.popupPresented,
        send: ChatMenuAction.dismissPopup
      )
    ) {
      TTPopupView.init(
        popUpCase: .twoLineTwoButton,
        title: "해당 채팅방에서\n나가시겠습니까?",
        leftButtonName: "취소",
        rightButtonName: "나가기",
        confirm: {
          viewStore.send(.roomExit)
        },
        cancel: {
          viewStore.send(.dismissPopup)
        }
      )
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
        
        Text(viewStore.roomInfo?.name ?? "")
          .foregroundColor(Color.white)
        Text("+ \(viewStore.unreadChatCount ?? 0)")
          .foregroundColor(Color.white)
        
        Spacer()
        
        Button {
          viewStore.send(.presentPopup)
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
  
  let colums = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
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
