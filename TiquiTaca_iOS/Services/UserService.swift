//
//  UserService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/13.
//

import TTNetworkModule
import Combine

protocol UserServiceType {
  var myProfile: UserEntity.Response? { get set }
  
  func fetchMyProfile() -> AnyPublisher<UserEntity.Response?, HTTPError>
  func deleteMyProfile()
  func updateFCMToken(_ request: FCMUpdateRequest) -> AnyPublisher<Void, HTTPError>
  func getOtherUserProfile(userId: String) -> AnyPublisher<UserEntity.Response?, HTTPError>
  func getAppAlarmState() -> AnyPublisher<AppAlarmEntity.Response?, HTTPError>
  func getBlockUserList() -> AnyPublisher<[BlockUserEntity.Response]?, HTTPError>
  func unBlockUser(userId: String) -> AnyPublisher<BlockUserEntity.Response?, HTTPError>
  func checkValidNickname(nickname: String) -> AnyPublisher<ValidNicknameEntity.Response?, HTTPError>
  func changeProfile(_ request: ChangeProfileEntity.Request) -> AnyPublisher<ChangeProfileEntity.Response?, HTTPError>
  func createUser(_ request: UserCreationEntity.Request) -> AnyPublisher<UserCreationEntity.Response?, HTTPError>
  func reportUser(userId: String) -> AnyPublisher<ReportEntity.Response?, HTTPError>
  func blockUser(userId: String) -> AnyPublisher<[BlockUserEntity.Response]?, HTTPError>
}

final class UserService: UserServiceType {
  private let network: Network<UserAPI>
  
  init() {
    network = .init()
  }
  
  var myProfile: UserEntity.Response?
  
  func deleteMyProfile() {
    myProfile = nil
  }
  
  func fetchMyProfile() -> AnyPublisher<UserEntity.Response?, HTTPError> {
    return network.request(.getMyProfile, responseType: UserEntity.Response.self)
      .handleEvents(receiveOutput: { [weak self] response in
        self?.myProfile = response
      })
      .eraseToAnyPublisher()
  }
  
  func updateFCMToken(_ request: FCMUpdateRequest) -> AnyPublisher<Void, HTTPError> {
    return network
      .request(.fcmPatch(request))
  }
  
  func getOtherUserProfile(userId: String) -> AnyPublisher<UserEntity.Response?, HTTPError> {
    return network.request(.getUserProfile(userId: userId), responseType: UserEntity.Response.self)
  }
  
  func getAppAlarmState() -> AnyPublisher<AppAlarmEntity.Response?, HTTPError> {
    return network.request(.alarm, responseType: AppAlarmEntity.Response.self)
  }
  
  func getBlockUserList() -> AnyPublisher<[BlockUserEntity.Response]?, HTTPError> {
    return network.request(.getBlockUserList, responseType: [BlockUserEntity.Response].self)
  }
  
  func unBlockUser(userId: String) -> AnyPublisher<BlockUserEntity.Response?, HTTPError> {
    return network.request(.unblockUser(userId: userId), responseType: BlockUserEntity.Response.self)
  }
  
  func checkValidNickname(nickname: String) -> AnyPublisher<ValidNicknameEntity.Response?, HTTPError> {
    return network.request(.validNickname(nickname: nickname), responseType: ValidNicknameEntity.Response.self)
  }
  
  func changeProfile(_ request: ChangeProfileEntity.Request) -> AnyPublisher<ChangeProfileEntity.Response?, HTTPError> {
    return network.request(.profilePatch(request), responseType: ChangeProfileEntity.Response.self)
  }
  
  func createUser(_ request: UserCreationEntity.Request) -> AnyPublisher<UserCreationEntity.Response?, HTTPError> {
    return network
      .request(.userCreate(request), responseType: UserCreationEntity.Response.self)
  }
  
  func reportUser(userId: String) -> AnyPublisher<ReportEntity.Response?, HTTPError> {
    return network.request(.reportUser(userId: userId), responseType: ReportEntity.Response.self)
  }
  
  func blockUser(userId: String) -> AnyPublisher<[BlockUserEntity.Response]?, HTTPError> {
    return network.request(.blockUser(userId: userId), responseType: [BlockUserEntity.Response].self)
  }
}
