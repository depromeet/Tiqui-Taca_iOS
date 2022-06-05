//
//  QuestionService.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/01.
//

import TTNetworkModule
import Combine

protocol QuestionServiceType {
  func getQuestionList(_ request: QuestionEntity.Request) -> AnyPublisher<[QuestionEntity.Response]?, HTTPError>
  func getQuestionDetail(questionId: String) -> AnyPublisher<QuestionEntity.Response?, HTTPError>
  func likeQuestion(questionId: String) -> AnyPublisher<QuestionLikeEntity.Response?, HTTPError>
  func postComment(questionId: String, _ request: QuestionCommentEntity.Request) -> AnyPublisher<QuestionCommentEntity.Response?, HTTPError>
  func deleteMyQuestion(questionId: String) -> AnyPublisher<QuestionEntity.Response?, HTTPError>
  func deleteMyComment(questionId: String, commentId: String) -> AnyPublisher<QuestionCommentEntity.Response?, HTTPError>
}

final class QuestionService: QuestionServiceType {
  private let network: Network<QuestionAPI>
  
  init() {
    network = .init()
  }
  
  func getQuestionList(_ request: QuestionEntity.Request) -> AnyPublisher<[QuestionEntity.Response]?, HTTPError> {
    network.request(.questionList(request), responseType: [QuestionEntity.Response].self)
  }
  
  func getQuestionDetail(questionId: String) -> AnyPublisher<QuestionEntity.Response?, HTTPError> {
    network.request(.questionDetail(questionId: questionId), responseType: QuestionEntity.Response.self)
  }
  
  func likeQuestion(questionId: String) -> AnyPublisher<QuestionLikeEntity.Response?, HTTPError> {
    network.request(.likeQuestion(questionId: questionId), responseType: QuestionLikeEntity.Response.self)
  }
  
  func postComment(questionId: String, _ request: QuestionCommentEntity.Request) -> AnyPublisher<QuestionCommentEntity.Response?, HTTPError> {
    network.request(.postComment(questionId: questionId, request), responseType: QuestionCommentEntity.Response.self)
  }
  
  func deleteMyQuestion(questionId: String) -> AnyPublisher<QuestionEntity.Response?, HTTPError> {
    network.request(.removeQuestion(questionId: questionId), responseType: QuestionEntity.Response.self)
  }
  
  func deleteMyComment(questionId: String, commentId: String) -> AnyPublisher<QuestionCommentEntity.Response?, HTTPError> {
    network.request(.removeComment(questionId: questionId, commentId: commentId), responseType: QuestionCommentEntity.Response.self)
  }
}
