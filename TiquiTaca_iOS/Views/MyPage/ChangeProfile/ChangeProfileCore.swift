//
//  ChangeProfileCore.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/09.
//
import TTNetworkModule
import ComposableArchitecture

struct ChangeProfileState: Equatable {
  var nickname: String = ""
  var profileImage: ProfileImage = .init()
  var bottomSheetPosition: TTBottomSheet.MiddlePosition = .hidden
  var nicknameError: NicknameError = .none
  var isAvailableCompletion: Bool = false
  
  var validNicknameCheck: Bool = false
  var popupPresented: Bool = false
  var dismissCurrentPage: Bool = false
}

enum ChangeProfileAction: Equatable {
  case doneButtonTapped
  case nicknameChanged(String)
  case setProfileImage(ProfileImage)
  case setBottomSheetPosition(TTBottomSheet.MiddlePosition)
  case presentPopup
  case dismissPopup
  case validNicknameResponse(Result<ValidNicknameEntity.Response?, HTTPError>)
  case checkNicknameResponse(Result<CheckNicknameEntity.Response?, HTTPError>)
  case changeProfile(String, ProfileType)
  case changeProfileResponse(Result<ChangeProfileEntity.Response?, HTTPError>)
}

struct ChangeProfileEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let changeProfileReducer = Reducer<
  ChangeProfileState,
  ChangeProfileAction,
  ChangeProfileEnvironment
> { state, action, environment in
  struct DebounceId: Hashable {}
  
  switch action {
  case .doneButtonTapped:
    return environment.appService.userService
      .checkValidNickname(nickname: state.nickname)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChangeProfileAction.validNicknameResponse)
    
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
      .map(ChangeProfileAction.checkNicknameResponse)
      .debounce(id: DebounceId(), for: .milliseconds(500), scheduler: environment.mainQueue)
    
  case let .validNicknameResponse(.success(response)):
    guard let response = response else { return .none }
    state.validNicknameCheck = response.canChange
    
    return state.validNicknameCheck ?
    Effect(value: .changeProfile(state.nickname, ProfileType(type: state.profileImage.type))) : .none
    
  case .validNicknameResponse(.failure):
    return .none
  
  case let .changeProfile(nickname, profileType):
    let request = ChangeProfileEntity.Request(
      nickname: nickname,
      profile: profileType
    )
    return environment.appService.userService
      .changeProfile(request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(ChangeProfileAction.changeProfileResponse)
    
  case let .changeProfileResponse(.success(response)):
    state.dismissCurrentPage = true
    return .none
    
  case .changeProfileResponse(.failure):
    state.nicknameError = .validation
    return .none
    
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
    
  case let .setBottomSheetPosition(position):
    state.bottomSheetPosition = position
    return .none
    
  case .dismissPopup:
    state.popupPresented = false
    return .none
    
  case .presentPopup:
    state.popupPresented = true
    return .none
  }
}
