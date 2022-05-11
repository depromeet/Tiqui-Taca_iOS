//
//  UserService.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/11.
//

import TTNetworkModule
import Combine

protocol UserServiceType {
  func getProfile() -> AnyPublisher<ProfileEntity.Response?, HTTPError>
  func getAppAlarmState() -> AnyPublisher<AppAlarmEntity.Response?, HTTPError>
}

final class UserService: UserServiceType {
  private let network: Network<UserAPI>
  
  init() {
    network = .init()
  }
  
  func getProfile() -> AnyPublisher<ProfileEntity.Response?, HTTPError> {
    return network.request(.getMyProfile, responseType: ProfileEntity.Response.self)
  }
  
  func getAppAlarmState() -> AnyPublisher<AppAlarmEntity.Response?, HTTPError> {
    return network.request(.alarm, responseType: AppAlarmEntity.Response.self)
  }
}
