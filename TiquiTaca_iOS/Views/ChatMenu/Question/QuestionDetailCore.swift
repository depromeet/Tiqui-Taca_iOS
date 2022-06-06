//
//  QuestionDetailCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/29.
//

import ComposableArchitecture
import TTNetworkModule
import TTDesignSystemModule
import IdentifiedCollections
import Foundation

struct QuestionDetailState: Equatable {
  var questionId: String
  var question: QuestionEntity.Response?
  var likesCount: Int = 0 // API response
  var likeActivated: Bool = false
  var selectedCommentId: String = ""
  var selectedCommentUserId: String = ""
  
  var bottomSheetPresented: Bool = false
  var bottomSheetPosition: TTBottomSheet.Position = .hidden
  var popupPresented: Bool = false
  var bottomSheetActionType: QuestionBottomActionType?
  var bottomType: QuestionBottomType?
  
  var questionInputMessageViewState: QuestionInputMessageState = .init()
  var commentMessage: String = ""
  
  var commentItemStates: IdentifiedArrayOf<CommentItemState> = []
}

enum QuestionDetailAction: Equatable {
  case moreClickAction
  case likeClickAction
  case writeComment
  
  case setBottomSheetPosition(TTBottomSheet.Position)
  case bottomSheetAction(QuestionBottomActionType)
  case presentPopup
  case dismissPopup
  case ttpopupConfirm
  
  case questionInputMessageView(QuestionInputMessageAction)
  case commentItemView(CommentItemAction)
  case comment(id: UUID, action: CommentItemAction)
  
  case getQuestionDetail
  case getQuestionDetailResponse(Result<QuestionEntity.Response?, HTTPError>)
  case likeClickResponse(Result<QuestionLikeEntity.Response?, HTTPError>)
  case postCommentResponse(Result<[QuestionCommentEntity.Response]?, HTTPError>)
  case reportQuestionWriter
  case reportQuestionWriterResponse(Result<ReportEntity.Response?, HTTPError>)
  case blockQuestionWriter
  case blockQuestionWriterResponse(Result<[BlockUserEntity.Response]?, HTTPError>)
  case deleteMyQuestion(String)
  case deleteMyQuestionResponse(Result<QuestionEntity.Response?, HTTPError>)
  case deleteMyComment(String, String)
  case deleteMyCommentResponse(Result<QuestionCommentEntity.Response?, HTTPError>)
  
  case reportCommentWriter(String)
  case blockCommentWriter(String)
}

struct QuestionDetailEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let questionDetailReducer = Reducer<
  QuestionDetailState,
  QuestionDetailAction,
  QuestionDetailEnvironment
>.combine([
  commentItemReducer
    .forEach(
      state: \.commentItemStates,
      action: /QuestionDetailAction.comment(id: action:),
      environment: { _ in
        CommentItemEnvironment()
      }
    ),
  questionInputMessageReducer
    .pullback(
      state: \.questionInputMessageViewState,
      action: /QuestionDetailAction.questionInputMessageView ,
      environment: { _ in
        QuestionInputMessageEnvironment()
      }
    ),
  questionDetailCore
])

let questionDetailCore = Reducer<
  QuestionDetailState,
  QuestionDetailAction,
  QuestionDetailEnvironment
> { state, action, environment in
  switch action {
  case .getQuestionDetail:
    state.question = nil
    state.commentItemStates.removeAll()
    
    return environment.appService.questionService
      .getQuestionDetail(questionId: state.questionId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.getQuestionDetailResponse)
  case let .getQuestionDetailResponse(.success(response)):
    state.question = response
    state.likesCount = response?.likesCount ?? 0
    state.likeActivated = response?.ilike ?? false
    
    state.question?.commentList.enumerated().forEach({ index, comment in
      state.commentItemStates.insert(CommentItemState(comment: comment), at: index)
    })
    
    return .none
  case .getQuestionDetailResponse(.failure):
    return .none
    
  case .likeClickAction:
    return environment.appService.questionService
      .likeQuestion(questionId: state.question?.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.likeClickResponse)
  case let .likeClickResponse(.success(response)):
    state.likeActivated = response?.ilike ?? false
    state.likesCount += state.likeActivated ? 1 : -1
    return .none
  case .likeClickResponse(.failure):
    return .none
    
  case .reportQuestionWriter:
    return environment.appService.userService
      .reportUser(userId: state.question?.user.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.reportQuestionWriterResponse)
  case let .reportQuestionWriterResponse(.success(response)):
//    if response.reportSuccess
    // 성공 Toast
    return .none
  case let .reportQuestionWriterResponse(.failure(error)):
    return .none
    
  case .blockQuestionWriter:
    return environment.appService.userService
      .blockUser(userId: state.question?.user.id ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.blockQuestionWriterResponse)
  case let .blockQuestionWriterResponse(.success(response)):
    // 성공 Toast
    return .none
  case .blockQuestionWriterResponse(.failure):
    return .none
    
  case let .reportCommentWriter(userId):
    return environment.appService.userService
      .reportUser(userId: userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.reportQuestionWriterResponse)

  case let .blockCommentWriter(userId):
    return environment.appService.userService
      .blockUser(userId: userId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.blockQuestionWriterResponse)
    
  case let .deleteMyQuestion(questionId):
    return environment.appService.questionService
      .deleteMyQuestion(questionId: questionId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.deleteMyQuestionResponse)
  case let .deleteMyQuestionResponse(.success(response)):
    return Effect(value: .getQuestionDetail)
  case .deleteMyQuestionResponse(.failure):
    return .none
    
  case let .deleteMyComment(questionId, commentId):
    return environment.appService.questionService
      .deleteMyComment(questionId: questionId, commentId: commentId)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(QuestionDetailAction.deleteMyCommentResponse)
  case let .deleteMyCommentResponse(.success(response)):
    state.commentItemStates = state.commentItemStates.filter { $0.comment?.id != state.selectedCommentId }
    
    state.selectedCommentId = ""
    state.selectedCommentUserId = ""
    return .none
  case .deleteMyCommentResponse(.failure):
    return .none
    
    
  case .moreClickAction:
    state.bottomSheetPosition = .threeButton
    if state.question?.user.id ?? "" == environment.appService.userService.myProfile?.id {
      state.bottomType = .contentMine
    } else {
      state.bottomType = .contentOther
    }
    return .none
  case .writeComment:
    return .none
  case .ttpopupConfirm:
    state.popupPresented = false
    
    switch state.bottomSheetActionType {
    case .like:
      return .none
    case .report:
      return Effect(value: .reportQuestionWriter)
    case .block:
      return Effect(value: .blockQuestionWriter)
    case .delete:
      return Effect(value: .deleteMyQuestion(state.questionId))
    case .commentReport:
      return Effect(value: .reportCommentWriter(state.selectedCommentUserId))
    case .commentBlock:
      return Effect(value: .blockCommentWriter(state.selectedCommentUserId))
    case .commentDelete:
      return Effect(value: .deleteMyComment(state.questionId, state.selectedCommentId))
    default:
      return .none
    }
  case let .setBottomSheetPosition(position):
    state.bottomSheetPosition = position
    return .none
  case let .bottomSheetAction(clickedType):
    state.bottomSheetPosition = .hidden
    
    switch clickedType {
    case .like:
      state.bottomSheetActionType = .like
      return Effect(value: .likeClickAction)
    case .report:
      state.bottomSheetActionType = .report
      return Effect(value: .presentPopup)
    case .delete:
      state.bottomSheetActionType = .delete
      return Effect(value: .presentPopup)
    case .block:
      state.bottomSheetActionType = .block
      return Effect(value: .presentPopup)
    case .commentReport:
      state.bottomSheetActionType = .commentReport
      return Effect(value: .presentPopup)
    case .commentBlock:
      state.bottomSheetActionType = .commentBlock
      return Effect(value: .presentPopup)
    case .commentDelete:
      state.bottomSheetActionType = .commentDelete
      return Effect(value: .presentPopup)
    }
    
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
    
  // 입력창 pullback
  case let .questionInputMessageView(questionInputMessageAction):
    switch questionInputMessageAction {
    case .sendMessage:
      state.commentMessage = state.questionInputMessageViewState.inputMessage
      
      let request = QuestionCommentEntity.Request(
        comment: state.commentMessage
      )
      return environment.appService.questionService
        .postComment(
          questionId: state.questionId,
          request
        )
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(QuestionDetailAction.postCommentResponse)
    case .messageTyping, .sendMessageAfter:
      return .none
    }
    
  case let .postCommentResponse(.success(response)):
    
    let addedComment = CommentEntity.init(
      id: response?.last?.id ?? "",
      comment: response?.last?.comment ?? "",
      user: response?.last?.user,
      createdAt: response?.last?.createdAt ?? ""
    )

    state.commentItemStates.insert(CommentItemState(comment: addedComment), at: state.commentItemStates.endIndex)
    return .none
  case .postCommentResponse(.failure):
    return .none
    
  case let .commentItemView(commentItemAction):
    return .none

  case let .comment(id: id, action: action):
    switch action {
    case let .moreClickAction(commentId, commentUserId):
      if commentUserId == environment.appService.userService.myProfile?.id {
        state.bottomType = .commentMine
      } else {
        state.bottomType = .commentOther
      }
      state.selectedCommentId = commentId
      state.selectedCommentUserId = commentUserId
      state.bottomSheetPosition = .twoButton
      return .none
    }
  }
}

enum QuestionBottomType {
  case contentOther
  case contentMine
  case commentOther
  case commentMine
  
  var bottomSheetPosition: TTBottomSheet.Position {
    switch self {
    case .contentOther:
      return .threeButton
    case .commentOther:
      return .twoButton
    case .contentMine, .commentMine:
      return .oneButton
    }
  }
  
  var bottomSheetTitle: String {
    switch self {
    case .contentOther:
      return "게시글"
    case .contentMine:
      return "내가 쓴 글"
    case .commentOther:
      return "댓글"
    case .commentMine:
      return "내가 쓴 댓글"
    }
  }
}

enum QuestionBottomActionType {
  case like
  case report
  case block
  case delete
  case commentReport
  case commentBlock
  case commentDelete
  
  var popupCase: TTPopup {
    switch self {
    case .report, .block, .commentReport, .commentBlock:
      return .oneLineTwoButton
    case .delete, .commentDelete:
      return .twoLineTwoButton
    default:
      return .oneLineTwoButton
    }
  }
  
  var title: String {
    switch self {
    case .like:
      return ""
    case .report:
      return "해당 게시물을\n신고 하시겠습니까?"
    case .block:
      return "해당 게시글 작성자를\n차단 하시겠습니까?"
    case .delete:
      return "해당 질문을 삭제 하시겠습니까?"
    case .commentReport:
      return "해당 댓글을\n신고 하시겠습니까?"
    case .commentBlock:
      return "해당 댓글 작성자를\n차단 하시겠습니까?"
    case .commentDelete:
      return "해당 댓글을 삭제 하시겠습니까?"
    }
  }
  
  var subtitle: String {
    switch self {
    case .delete:
      return "삭제된 질문은 영구적으로 삭제되어 복구할 수 없습니다."
    case .commentDelete:
      return "삭제된 댓글은 영구적으로 삭제되어 복구할 수 없습니다."
    default:
      return ""
    }
  }
  
  var rightButtonName: String {
    switch self {
    case .like:
      return ""
    case .report, .commentReport:
      return "신고하기"
    case .block, .commentBlock:
      return "차단하기"
    case .delete, .commentDelete:
      return "삭제하기"
    }
  }
}
