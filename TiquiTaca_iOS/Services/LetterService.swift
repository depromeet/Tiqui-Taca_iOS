//
//  LetterService.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/09.
//

import TTNetworkModule
import Combine

protocol LetterServiceType {
  func getLetterList() -> AnyPublisher<[LetterSummaryEntity.Response]?, HTTPError>
  func leaveLetterRoom(letterRoomId: String) -> AnyPublisher<[LetterSummaryEntity.Response]?, HTTPError>
  func getLetterRoomInfo(letterRoomId: String) -> AnyPublisher<[LetterEntity.Response]?, HTTPError>
  func sendLetter(userId: String, _ request: LetterEntity.Request) -> AnyPublisher<LetterEntity.Response?, HTTPError>
}

final class LetterService: LetterServiceType {
  private let network: Network<LetterAPI>
  
  init() {
    network = .init()
  }
  
  func getLetterList() -> AnyPublisher<[LetterSummaryEntity.Response]?, HTTPError> {
    network.request(.letterTab, responseType: [LetterSummaryEntity.Response].self)
  }
  
  func leaveLetterRoom(letterRoomId: String) -> AnyPublisher<[LetterSummaryEntity.Response]?, HTTPError> {
    network.request(.leaveLetterRoom(roomId: letterRoomId), responseType: [LetterSummaryEntity.Response].self)
  }
  
  func getLetterRoomInfo(letterRoomId: String) -> AnyPublisher<[LetterEntity.Response]?, HTTPError> {
    network.request(.getLetterRoomInfo(roomId: letterRoomId), responseType: [LetterEntity.Response].self)
  }
  
  func sendLetter(userId: String, _ request: LetterEntity.Request) -> AnyPublisher<LetterEntity.Response?, HTTPError> {
    network.request(.sendLetter(userId: userId, request), responseType: LetterEntity.Response.self)
  }
}
