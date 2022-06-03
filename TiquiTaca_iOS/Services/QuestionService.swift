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
}
