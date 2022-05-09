//
//  AuthService.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/21.
//

import TTNetworkModule
import Combine

protocol AuthServiceType {
  var isLoggedIn: Bool { get }
  func verification(request: VerificationEntity.Request) -> AnyPublisher<VerificationEntity.Response?, HTTPError>
  func issuePhoneCode(request: IssueCodeEntity.Request) -> AnyPublisher<IssueCodeEntity.Response?, HTTPError>
  func tokenRefresh(request: TokenRefreshEntity.Request) -> AnyPublisher<TokenRefreshEntity.Response?, HTTPError>
}

final class AuthService: AuthServiceType {
  private let network: Network<AuthAPI>
  
  var isLoggedIn: Bool {
    if TokenManager.shared.loadRefreshToken() == nil {
      return false
    } else {
      return true
    }
  }
  
  init() {
    network = .init()
  }
  
  func verification(request: VerificationEntity.Request) -> AnyPublisher<VerificationEntity.Response?, HTTPError> {
    return network
      .request(.authVerification(request), responseType: VerificationEntity.Response.self)
  }
  
  func issuePhoneCode(request: IssueCodeEntity.Request) -> AnyPublisher<IssueCodeEntity.Response?, HTTPError> {
    return network
      .request(.authIssueCode(request), responseType: IssueCodeEntity.Response.self)
  }
  
  func tokenRefresh(request: TokenRefreshEntity.Request) -> AnyPublisher<TokenRefreshEntity.Response?, HTTPError> {
    return network
      .request(.authTokenRefresh(request), responseType: TokenRefreshEntity.Response.self)
  }
}
