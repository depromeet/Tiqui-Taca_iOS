//
//  CreateProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import TTNetworkModule
import ComposableArchitecture

enum NicknameError {
  case validation
  case duplication
  case none
  
  var description: String {
    switch self {
    case .validation:
      return "모음이나 자음을 단독으로 쓸 수는 없어요."
    case .duplication:
      return "중복된 이름은 사용할 수 없어요!\n다른 이름을 입력해주세요."
    case .none:
      return "티키타카에서 사용할 닉네임과 프로필을 선택해주세요.\n닉네임은 최대 10자까지 입력이 가능해요!"
    }
  }
}

struct CreateProfileState: Equatable {
  var phoneNumber: String = ""
  var isAgreed: Bool = false
  
  var nickname: String = ""
  var profileImage: ProfileImage = .init()
  var isSheetPresented: Bool = false
  var nicknameError: NicknameError = .none
  var isAvailableCompletion: Bool = false
}

enum CreateProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case setProfileImage(ProfileImage)
  case setBottomSheet(Bool)
  case checkNicknameResponse(Result<CheckNicknameEntity.Response?, HTTPError>)
  case createUserSuccess
  case createUserResponse(Result<UserCreationEntity.Response?, HTTPError>)
}

struct CreateProfileEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let createProfileReducer = Reducer<
  CreateProfileState,
  CreateProfileAction,
  CreateProfileEnvironment
> { state, action, environment in
  struct DebounceId: Hashable {}
  
  switch action {
  case .doneButtonTapped:
    let request = UserCreationEntity.Request(
      phoneNumber: state.phoneNumber,
      nickname: state.nickname,
      profileImageType: state.profileImage.type,
      isAgreed: state.isAgreed,
      FCMToken: environment.appService.fcmToken ?? ""
    )
    return environment.appService.userService
      .createUser(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(CreateProfileAction.createUserResponse)
    
  case let .nicknameChanged(nickname):
    if state.nickname == nickname {
      return .none
    }
    state.nickname = nickname
    
    if state.nickname.isEmpty {
      state.nicknameError = .none
      state.isAvailableCompletion = false
      return .none
    }
    
    if !nickname.checkNickname() {
      state.nicknameError = .validation
      state.isAvailableCompletion = false
      return .none
    }
    
    let request = CheckNicknameEntity.Request(nickname: nickname)
    return environment.appService.authService
      .checkNickname(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(CreateProfileAction.checkNicknameResponse)
      .debounce(id: DebounceId(), for: .milliseconds(500), scheduler: environment.mainQueue)
    
  case let .checkNicknameResponse(.success(response)):
    guard let response = response,
          !state.nickname.isEmpty
    else { return .none }
    state.isAvailableCompletion = !response.isExist
    state.nicknameError = response.isExist ? .duplication : .none
    return .none
    
  case .checkNicknameResponse(.failure):
    return .none
    
  case let .setProfileImage(profileImage):
    state.profileImage = profileImage
    return .none
    
  case let .setBottomSheet(isPresent):
    state.isSheetPresented = isPresent
    return .none
    
  case .createUserSuccess:
    return .none
    
  case let .createUserResponse(.success(response)):
    guard let response = response else { return .none }
    environment.appService.authService
      .saveToken(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken
      )
    return Effect(value: .createUserSuccess)
    
  case .createUserResponse(.failure):
    return .none
  }
}
