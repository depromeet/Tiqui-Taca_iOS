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
  @Binding var shouldPopToRootView: Bool
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  struct ViewState: Equatable {
    let route: State.Route?
    
    let roomInfo: RoomInfoEntity.Response?
    let roomUserList: [UserEntity.Response]
    let questionList: [QuestionEntity.Response]
    let totalQuestionCount: Int
    
    let popupPresented: Bool
    let isExistRoom: Bool
    let isFavorite: Bool
    let showOtherProfile: Bool
    let questionDetailViewState: QuestionDetailState
    let questionListViewState: QuestionListState
    
    init(state: State) {
      route = state.route
      roomInfo = state.roomInfo
      roomUserList = state.roomUserList
      questionList = state.questionList
      totalQuestionCount = state.totalQuestionCount
      popupPresented = state.popupPresented
      isFavorite = state.isFavorite
      
      isExistRoom = state.isExistRoom
      showOtherProfile = state.showOtherProfile
      questionDetailViewState = state.questionDetailViewState
      questionListViewState = state.questionListViewState
    }
  }
  
  init(store: Store<State, Action>, shouldPopToRootView: Binding<Bool>) {
    self._shouldPopToRootView = shouldPopToRootView
    self.store = store
    self.viewStore = ViewStore.init(store.scope(state: ViewState.init))
    self.shouldPopToRootView = viewStore.state.isExistRoom
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      topNavigationView
      List {
        Section {
          listHeader
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        Section {
          VStack(alignment: .leading, spacing: 0) {
            Text("현재 티키타카 중인 사람들")
              .font(.heading3)
              .foregroundColor(.black800)
              .padding(.bottom, .spacingXXS)
              .padding(.top, 16)
            
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
                  .frame(width: 79, height: 88)
                  .onTapGesture {
                    viewStore.send(.profileSelected(participant))
                  }
                }
              }
            }
            .background(Color.white)
            .listStyle(.plain)
            .padding()
          }
          .listRowInsets(EdgeInsets(top: 4, leading: 15, bottom: 4, trailing: 15))
          .listRowSeparator(.hidden)
          .background(Color.white)
        }
      }
      .listStyle(.plain)
      .frame(maxHeight: .infinity)
      
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
              action: ChatMenuAction.questionDetailView
            )
          )
        },
        label: EmptyView.init
      )
      
      NavigationLink(
        tag: State.Route.questionList,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          QuestionListView(
            store: store.scope(
              state: \.questionListViewState,
              action: ChatMenuAction.questionListView
            )
          )
        },
        label: EmptyView.init
      )
      
      NavigationLink(
        tag: State.Route.sendLetter,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          LetterSendView(
            store: store.scope(
              state: \.letterSendState,
              action: ChatMenuAction.letterSendAction
            )
          )
        },
        label: EmptyView.init
      )
    }
    .background(Color.white)
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
    .ignoresSafeArea()
//    .overlay(
//      OtherProfileView(
//        store: store.scope(
//          state: \.otherProfileState,
//          action: ChatMenuAction.otherProfileAction
//        ),
//        showView: $showOtherProfile,
//        sendLetter: { userInfo in
//          viewStore.send(.selectSendLetter(userInfo))
//        }
//      )
//      .opacity(showOtherProfile ? 1 : 0),
//      alignment: .center
//    )
    .overlay(
      OtherProfileView(
        store: store.scope(
          state: \.otherProfileState,
          action: ChatMenuAction.otherProfileAction
        ),
        showView: viewStore.binding(
          get: \.showOtherProfile,
          send: ChatMenuAction.setShowOtherProfile
        ),
        sendLetter: { userInfo in
          viewStore.send(.letterSendSelected(userInfo))
        },
        actionHandler: { action in
          
        }
      )
      .opacity(viewStore.showOtherProfile ? 1 : 0),
      alignment: .center
    )
    .onAppear(perform: {
      viewStore.send(.getRoomUserListInfo)
      viewStore.send(.getQuestionList)
    })
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
          .font(.subtitle2)
          .foregroundColor(Color.white)
        Text("+\(viewStore.roomInfo?.userCount ?? 0)")
          .font(.subtitle2)
          .foregroundColor(Color.white)
        
        Spacer()
        
        HStack(spacing: 4) {
          Button {
            viewStore.send(.roomFavoriteSelect)
          } label: {
            Image(viewStore.isFavorite ? "chatFavorite" : "chatFavoriteDisabled")
          }
          Button {
            viewStore.send(.presentPopup)
          } label: {
            Image("chat_exit")
          }
        }
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.black800)
    .frame(height: 88)
  }
  
  var listHeader: some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        if viewStore.questionList.isEmpty {
          VStack(alignment: .center, spacing: 0) {
            Spacer()
              .padding(.top, 78)
            Image("bxNoAnswer")
              .resizable()
              .frame(width: 108, height: 108)
              .padding(16)
            Text("아직 사용자들이 남긴 질문이 없어요!\n처음으로 질문을 남겨보세요!")
              .multilineTextAlignment(.center)
              .lineSpacing(14 * 0.32)
              .font(.body2)
              .foregroundColor(.white900)
            Spacer()
              .padding(.bottom, 90)
          }
          .frame(maxWidth: .infinity, maxHeight: 336)
        } else {
          Text("최근 등록된 질문")
            .font(.heading3)
            .foregroundColor(.black800)
            .padding(.bottom, .spacingXXS)
          Text("총 \(viewStore.totalQuestionCount)개의 질문")
            .font(.body7)
            .foregroundColor(.black100)
            .padding(.bottom, 20)
          
          ForEach(viewStore.questionList) { question in
            Button {
              viewStore.send(.questionSelected(question.id))
            } label: {
              QuestionItemView(model: question)
                .padding([.top, .bottom], 4)
            }
          }
          .buttonStyle(.plain)
        }
        
        Button {
          viewStore.send(.questionListButtonClicked)
        } label: {
          Text("질문 전체보기")
        }
        .frame(height: 48)
        .buttonStyle(TTButtonLargeBlackStyle())
        .padding(.top, 16)
      }
      .padding(15)
      
      Rectangle().fill(Color.white50)
        .frame(maxWidth: .infinity, maxHeight: 8)
    }
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
      ), shouldPopToRootView: .constant(true)
    )
  }
}
