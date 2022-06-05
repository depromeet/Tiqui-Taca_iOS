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
    let question: QuestionEntity.Response?
    let likesCount: Int
    let likeActivated: Bool
    let commentCount: Int
    
    let bottomSheetPresented: Bool
    let bottomSheetPosition: TTBottomSheet.Position
    let popupPresented: Bool
    let bottomSheetActionType: QuestionBottomActionType?
    let bottomType: QuestionBottomType?
    
    let questionInputMessageViewState: QuestionInputMessageState
    let commentMessage: String
    
    let commentItemStates: IdentifiedArrayOf<CommentItemState>
    
    init(state: State) {
      question = state.question
      likesCount = state.likesCount
      likeActivated = state.likeActivated
      commentCount = state.commentCount
      
      bottomSheetPresented = state.bottomSheetPresented
      bottomSheetPosition = state.bottomSheetPosition
      popupPresented = state.popupPresented
      bottomSheetActionType = state.bottomSheetActionType
      bottomType = state.bottomType
      
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
      
      VStack(alignment: .leading) {
        HStack(alignment: .top) {
          Image(viewStore.question?.user.profile.imageName ?? "defaultProfile")
            .resizable()
            .frame(width: 32, height: 32)
          
          VStack(alignment: .leading) {
            Text(viewStore.question?.user.nickname ?? "")
              .font(.body4)
              .foregroundColor(.black900)
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
        }
        
        VStack(alignment: .leading) {
          Text(viewStore.question?.content ?? "")
            .font(.body3)
            .foregroundColor(.black900)
            .hLeading()
          HStack {
            Image(viewStore.likeActivated ? "replyGoodOn" : "replyGoodOff")
            Text("\(viewStore.likesCount)")
              .font(.body7)
              .foregroundColor(.white800)
            
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
//          ForEachStore(
//            store.scope(
//              state: \.commentItemStates,
//              action: Action.comment(id:action:)
//            ),
//            content: CommentItemView.init(store: )
//          )
          ForEachStore(
            store.scope(
              state: \.commentItemStates,
              action: Action.comment(id:action:)
            ), content: { store in
              CommentItemView.init(store: store)
            }
          )
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
          .background(Color.white)
        }
        .listStyle(.plain)
      } else {
        VStack(alignment: .center) {
          Spacer()
          Image("bxPancil")
            .resizable()
            .frame(width: 160, height: 160)
            .padding(.spacingM)
          Text("아직 사용자들이 남긴 답변이 없어요!\n처음으로 질문에 답변해보세요!")
            .font(.body2)
            .foregroundColor(.white900)
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      Spacer()
      
      QuestionInputMessageView(
        store: questionInputStore
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
        Text(viewStore.bottomType?.bottomSheetTitle ?? "")
          .font(.body2)
          .foregroundColor(.black100)
          .hCenter()
          .frame(height: 10)
          .padding(12)
        
        Rectangle().fill(Color.black600)
          .frame(height: 1)
          .hCenter()
        
        if viewStore.bottomType == .contentOther ||
            viewStore.bottomType == .commentOther {
          Button {
            viewStore.send(.bottomSheetAction(.like))
          } label: {
            Text("좋아요")
              .hCenter()
              .font(.subtitle2)
              .foregroundColor(.white)
          }
          .frame(height: viewStore.bottomType == .contentOther ? 44 : 0)
          
          Rectangle().fill(Color.black600)
            .frame(height: viewStore.bottomType == .contentOther ? 1 : 0)
            .hCenter()
          
          Button {
            if viewStore.bottomType == .contentOther {
              viewStore.send(.bottomSheetAction(.report))
            } else if viewStore.bottomType == .commentOther {
              viewStore.send(.bottomSheetAction(.commentReport))
            }
          } label: {
            Text("신고하기")
              .hCenter()
              .font(.subtitle2)
              .foregroundColor(.white)
          }
          .frame(height: 44)
          
          Rectangle().fill(Color.black600)
            .frame(height: 1)
            .hCenter()
          
          Button {
            if viewStore.bottomType == .contentOther {
              viewStore.send(.bottomSheetAction(.block))
            } else if viewStore.bottomType == .commentOther {
              viewStore.send(.bottomSheetAction(.commentBlock))
            }
          } label: {
            Text("차단하기")
              .hCenter()
              .font(.subtitle2)
              .foregroundColor(.white)
          }
          .frame(height: 44)
          Spacer()
        } else {
          Button {
            if viewStore.bottomType == .contentMine {
              viewStore.send(.bottomSheetAction(.delete))
            } else if viewStore.bottomType == .commentMine {
              viewStore.send(.bottomSheetAction(.commentDelete))
            }
          } label: {
            Text("삭제하기")
              .hCenter()
              .font(.subtitle2)
              .foregroundColor(.errorRed)
          }
          .frame(height: 44)
          Spacer()
        }
      }
      .vCenter()
      .hCenter()
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
          .foregroundColor(.white)
        
        Text("님의 질문")
          .font(.subtitle2)
          .foregroundColor(.black200)
        
        Spacer()
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 10)
      .padding(.bottom, 10)
      .frame(height: 44)
    }
    .background(Color.black800)
  }
}

private struct InputMessageView: View {
  @State var typingMessage: String = ""
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      HStack(alignment: .center, spacing: 4) {
        TextEditor(text: $typingMessage)
          .foregroundColor(Color.black900)
          .font(.body4)
          .background(
            ZStack {
              Text(
                typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                "텍스트를 남겨주세요" : ""
              )
              .foregroundColor(Color.black100)
              .font(.body4)
              .padding(.leading, 4)
              .hLeading()
            }
          )
          .hLeading()
          .frame(alignment: .center)
        
        VStack(spacing: 0) {
          Spacer()
            .frame(minHeight: 0, maxHeight: .infinity)
          Button {
            
          } label: {
            Image("sendDisable")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(
                typingMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                Color.black100 :
                  Color.green700
              )
              .frame(width: 24, height: 32)
          }
        }
      }
      .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
      .padding(0)
      .frame(height: 52)
      .background(Color.white150)
      .cornerRadius(16)
      .hLeading()
    }
    .padding(8)
    .background(Color.white50)
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
