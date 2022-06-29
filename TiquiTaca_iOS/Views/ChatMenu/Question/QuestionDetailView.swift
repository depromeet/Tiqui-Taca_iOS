//
//  QuestionDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule
import IdentifiedCollections

struct QuestionDetailView: View {
  typealias State = QuestionDetailState
  typealias Action = QuestionDetailAction
  
  let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  struct ViewState: Equatable {
    let route: QuestionDetailState.Route?
    let question: QuestionEntity.Response?
    let likesCount: Int
    let likeActivated: Bool
    
    let showOtherProfile: Bool
    let bottomSheetPresented: Bool
    let popupPresented: Bool
    let bottomSheetActionType: QuestionBottomActionType?
    let bottomType: QuestionBottomType?
    let sheetPresented: Bool
    
    let questionInputMessageViewState: QuestionInputMessageState
    let commentMessage: String
    
    let commentItemStates: IdentifiedArrayOf<CommentItemState>
    
    init(state: State) {
      route = state.route
      question = state.question
      likesCount = state.likesCount
      likeActivated = state.likeActivated
      
      showOtherProfile = state.showOtherProfile
      bottomSheetPresented = state.bottomSheetPresented
      //      bottomSheetPosition = state.bottomSheetPosition
      popupPresented = state.popupPresented
      bottomSheetActionType = state.bottomSheetActionType
      bottomType = state.bottomType
      sheetPresented = state.sheetPresented
      
      questionInputMessageViewState = state.questionInputMessageViewState
      commentMessage = state.commentMessage
      
      commentItemStates = state.commentItemStates
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      topNavigationView
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
              action: QuestionDetailAction.letterSendAction
            )
          )
        },
        label: EmptyView.init
      )
      List {
        listHeader
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
        Section {
          if let commentList = viewStore.commentItemStates, !commentList.isEmpty {
            VStack {
              Text("댓글 \(viewStore.commentItemStates.count)")
                .hLeading()
                .font(.subtitle1)
                .foregroundColor(.black800)
                .padding(.leading, 20)
                .padding(.top, 12)
              
              ForEachStore(
                store.scope(
                  state: \.commentItemStates,
                  action: Action.comment(id:action:)
                ), content: { store in
                  CommentItemView.init(store: store)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
              )
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
          } else {
            VStack(alignment: .center) {
              Spacer()
              Image("bxPancil")
                .resizable()
                .frame(width: 160, height: 160)
                .padding(.spacingM)
              Text("아직 사용자들이 남긴 답변이 없어요!\n처음으로 질문에 답변해보세요!")
                .multilineTextAlignment(.center)
                .lineSpacing(14 * 0.32)
                .font(.body2)
                .foregroundColor(.white900)
              Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
          }
        }
        .background(Color.white)
      }
      .listStyle(.plain)
      .frame(maxHeight: .infinity)
      
      QuestionInputMessageView(
        store: questionInputStore
      )
    }
    .actionSheet(
      isPresented:
        viewStore.binding(
          get: \.sheetPresented,
          send: QuestionDetailAction.dismissSheet
        )
    ) {
      switch viewStore.bottomType {
      case .contentOther:
        return ActionSheet(
          title: Text(viewStore.state.bottomType?.bottomSheetTitle ?? ""),
          buttons: [
            .default(Text("좋아요")) {
              viewStore.send(.bottomSheetAction(.like))
            },
            .default(Text("신고하기")) {
              viewStore.send(.bottomSheetAction(.report))
            },
            .default(Text("차단하기")) {
              viewStore.send(.bottomSheetAction(.block))
            },
            .cancel(Text("취소")) {
              viewStore.send(.dismissSheet)
            }
          ]
        )
      case .contentMine:
        return ActionSheet(
          title: Text(viewStore.state.bottomType?.bottomSheetTitle ?? ""),
          buttons: [
            .destructive(Text("삭제하기")) {
              viewStore.send(.bottomSheetAction(.delete))
            },
            .cancel(Text("취소"))
          ]
        )
      case .commentOther:
        return ActionSheet(
          title: Text(viewStore.state.bottomType?.bottomSheetTitle ?? ""),
          buttons: [
            .default(Text("신고하기")) {
              viewStore.send(.bottomSheetAction(.commentReport))
            },
            .default(Text("차단하기")) {
              viewStore.send(.bottomSheetAction(.commentBlock))
            },
            .cancel(Text("취소"))
          ]
        )
      case .commentMine:
        return ActionSheet(
          title: Text(viewStore.state.bottomType?.bottomSheetTitle ?? ""),
          buttons: [
            .destructive(Text("삭제하기")) {
              viewStore.send(.bottomSheetAction(.commentDelete))
            },
            .cancel(Text("취소"))
          ]
        )
      case .none:
        return ActionSheet(title: Text(""))
      }
    }
    .ttPopup(
      isShowing: viewStore.binding(
        get: \.popupPresented,
        send: QuestionDetailAction.dismissPopup
      )
    ) {
      TTPopupView.init(
        popUpCase:
          viewStore.bottomSheetActionType?.popupCase ?? .oneLineTwoButton,
        title: viewStore.bottomSheetActionType?.title ?? "",
        subtitle: viewStore.bottomSheetActionType?.subtitle ?? "",
        leftButtonName: "취소",
        rightButtonName: viewStore.bottomSheetActionType?.rightButtonName ?? "",
        confirm: {
          viewStore.send(.ttpopupConfirm)
        },
        cancel: {
          viewStore.send(.dismissPopup)
        }
      )
    }
    .overlay(
      OtherProfileView(
        store: store.scope(
          state: \.otherProfileState,
          action: QuestionDetailAction.otherProfileAction
        ),
        showView: viewStore.binding(
          get: \.showOtherProfile,
          send: QuestionDetailAction.setShowOtherProfile
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
    .onAppear {
      viewStore.send(.getQuestionDetail)
    }
    .navigationBarHidden(true)
    .background(Color.white)
    .hideKeyboardWhenTappedAround()
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          self.presentationMode.wrappedValue.dismiss()
        } label: {
          Image("chat_backButton")
        }
        
        Text(viewStore.question?.user.nickname ?? "")
          .font(.subtitle2)
          .foregroundColor(
            viewStore.question?.user.status == UserStatus.signOut ? .black50: .white)
        
        Text("님의 질문")
          .font(.subtitle2)
          .foregroundColor(.black200)
        
        Spacer()
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 10)
      .padding(.bottom, 10)
    }
    .background(Color.black800)
    .frame(height: 38)
  }
  
  var listHeader: some View {
    VStack {
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Image(viewStore.question?.user.profile.imageName ?? "defaultProfile")
            .resizable()
            .frame(width: 32, height: 32)
            .onTapGesture {
              viewStore.send(.profileSelected(viewStore.question?.user))
            }
          
          VStack(alignment: .leading) {
            Text(viewStore.question?.user.nickname ?? "")
              .font(.body4)
              .foregroundColor(viewStore.question?.user.status == UserStatus.signOut ? .black50: .black900)
            Text(viewStore.question?.createdAt.getTimeTodayOrDate() ?? "")
              .font(.body8)
              .foregroundColor(.white800)
          }
          
          Spacer()
          
          Button {
            viewStore.send(.moreClickAction)
          } label: {
            Image("moreVertical")
          }
          .buttonStyle(.plain)
        }
        
        VStack(alignment: .leading) {
          Text(viewStore.question?.content ?? "")
            .font(.body3)
            .foregroundColor(.black900)
            .hLeading()
          HStack(spacing: 0) {
            Image(viewStore.likeActivated ? "replyGoodOn" : "replyGoodOff")
            Text("\(viewStore.likesCount)")
              .font(.body7)
              .foregroundColor(.white800)
              .padding(.leading, 2)
              .padding(.trailing, 10)
            
            Image("comments")
              .resizable()
              .frame(width: 20, height: 20)
            Text("\(viewStore.commentItemStates.count)")
              .font(.body7)
              .foregroundColor(.white800)
              .padding(.leading, 2)
          }
        }
      }
      .padding([.leading, .trailing], 20)
      .padding(.top, 24)
      .padding(.bottom, 18)
      
      Spacer()
        .frame(maxWidth: .infinity, maxHeight: 8)
        .background(Color.white100)
    }
    .background(Color.white)
  }
}

extension QuestionDetailView {
  private var questionInputStore: Store<QuestionInputMessageState, QuestionInputMessageAction> {
    return store.scope(
      state: \.questionInputMessageViewState,
      action: Action.questionInputMessageView
    )
  }
}

struct QuestionDetailView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionDetailView(
      store: .init(
        initialState: QuestionDetailState(questionId: ""),
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
