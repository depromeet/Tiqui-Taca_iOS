//
//  UserService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/13.
//

import TTNetworkModule
import Combine

protocol UserServiceType {
  func createUser(_ request: UserCreationEntity.Request) -> AnyPublisher<UserCreationEntity.Response?, HTTPError>
}

final class UserService: UserServiceType {
  private let network: Network<UserAPI>
  
  init() {
    network = .init()
  }
  
  // token 저장 관련 메서드 추가할 것
  
  func createUser(_ request: UserCreationEntity.Request) -> AnyPublisher<UserCreationEntity.Response?, HTTPError> {
    return network
      .request(.userCreate(request), responseType: UserCreationEntity.Response.self)
  }
  
//  func getMyInfo() ->
}
