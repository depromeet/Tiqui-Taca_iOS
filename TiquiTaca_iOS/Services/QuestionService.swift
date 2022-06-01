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
}

final class QuestionService: QuestionServiceType {
  private let network: Network<QuestionAPI>
  
  init() {
    network = .init()
  }
  
  func getQuestionList(_ request: QuestionEntity.Request) -> AnyPublisher<[QuestionEntity.Response]?, HTTPError> {
    network.request(.questionList(request), responseType: [QuestionEntity.Response].self)
  }
}
