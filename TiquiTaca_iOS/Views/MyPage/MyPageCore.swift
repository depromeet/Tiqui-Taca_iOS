//
//  MyPageCore.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import ComposableArchitecture
import TTNetworkModule
import IdentifiedCollections

struct MyPageState: Equatable {
  typealias Route = MyPageItemType
  var route: Route?
  var myInfoViewState: MyInfoState = .init()
  var changeProfileViewState: ChangeProfileState = .init()
  var noticeViewState: NoticeState = .init()
  var myPageItemStates: IdentifiedArrayOf<MyPageItemState> = [
    .init(rowInfo: .init(itemType: .myInfoView)),
    .init(rowInfo: .init(itemType: .alarmSet, toggleVisible: true)),
    .init(rowInfo: .init(itemType: .blockHistoryView)),
    .init(rowInfo: .init(itemType: .noticeView)),
    .init(rowInfo: .init(itemType: .myTermsOfServiceView)),
    .init(rowInfo: .init(itemType: .csCenterView)),
    .init(rowInfo: .init(itemType: .versionInfo, description: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String))
  ]
  
  var nickname = ""
  var phoneNumber = ""
  var profileImage: ProfileImage = .init()
  var level = 1
  var lightningScore = 0
  var createdAt: String = ""
  var createDday = 0
  var isAppAlarmOn = false
  var toastPresented = false
}

enum MyPageAction: Equatable {
  case setRoute(MyPageState.Route?)
  case myInfoView(MyInfoAction)
  case changeProfileView(ChangeProfileAction)
  case noticeView(NoticeAction)
  case mypageItemView(MyPageItemAction)
  case mypageItem(id: UUID, action: MyPageItemAction)
  case getProfileInfo
  case getProfileInfoResponse(Result<UserEntity.Response?, HTTPError>)
  case getProfileRequestSuccess
  case logout
  case withdrawal
  case dismissToast
}

struct MyPageEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let myPageReducer = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
>.combine([
  changeProfileReducer
    .pullback(
      state: \.changeProfileViewState,
      action: /MyPageAction.changeProfileView,
      environment: {
        ChangeProfileEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  myInfoReducer
    .pullback(
      state: \.myInfoViewState,
      action: /MyPageAction.myInfoView,
      environment: { _ in
        MyInfoEnvironment()
      }
    ),
  myPageItemReducer
    .forEach(
      state: \.myPageItemStates,
      action: /MyPageAction.mypageItem(id:action:),
      environment: {
        MyPageItemEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  noticeReducer
    .pullback(
      state: \.noticeViewState,
      action: /MyPageAction.noticeView,
      environment: {
        NoticeEnvironment(
          appService: $0.appService,
          mainQueue: $0.mainQueue
        )
      }
    ),
  myPageReducerCore
])

let myPageReducerCore = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
> { state, action, environment in
  switch action {
  case .getProfileInfo:
    return environment.appService.userService
      .fetchMyProfile()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(MyPageAction.getProfileInfoResponse)
  case let .getProfileInfoResponse(.success(response)):
    let myProfile = response //environment.appService.userService.myProfile
    state.profileImage.type = myProfile?.profile.type ?? 0
    state.nickname = myProfile?.nickname ?? ""
    state.isAppAlarmOn = myProfile?.appAlarm ?? false
    state.level = myProfile?.level ?? 0
    state.lightningScore = myProfile?.lightningScore ?? 0
    state.phoneNumber = myProfile?.phoneNumber ?? ""
    state.changeProfileViewState = ChangeProfileState(nickname: state.nickname, changedNickname: state.nickname, profileImage: state.profileImage)
    state.myPageItemStates.remove(at: 1)
    state.myPageItemStates.insert(.init(rowInfo: .init(itemType: .alarmSet, toggleVisible: true), isAppAlarmOn: state.isAppAlarmOn), at: 1)
    
    if var phoneNumber = myProfile?.phoneNumber, phoneNumber.count > 9 {
      phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
      phoneNumber.insert("-", at: phoneNumber.index(phoneNumber.endIndex, offsetBy: -4))
      
      state.phoneNumber = phoneNumber
    }
    
    let createdDateString = myProfile?.createdAt ?? ""
    let iso8601Formatter = ISO8601DateFormatter()
    let createdDate = iso8601Formatter.date(from: createdDateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    
    state.createdAt = dateFormatter.string(for: createdDate) ?? ""
    state.createDday = Calendar(identifier: .gregorian)
      .dateComponents([.day], from: createdDate ?? Date(), to: Date()).day ?? 0
    
    state.myInfoViewState = .init(nickname: state.nickname, phoneNumber: state.phoneNumber, createdAt: state.createdAt)
    return Effect(value: .getProfileRequestSuccess)
  case .getProfileInfoResponse(.failure):
    return .none
  case .getProfileRequestSuccess:
    return .none
    
  case .logout:
    return .none
    
  case let .setRoute(route):
    if route == .alarmSet {
      state.route = nil
      return .none
    } else if route == .versionInfo {
      state.route = nil
      return .none
    } else {
      state.route = route
      return .none
    }
    
  case let .changeProfileView(changeProfileAction):
    switch changeProfileAction {
    case .getMyProfileResponse:
      state.toastPresented = true
      return .none
    default:
      return .none
    }
    
  case .mypageItemView:
    return .none
  case let .mypageItem(id: id, action: action):
    switch action {
    case let .mypageItemTapped(itemType):
      return Effect(value: .setRoute(itemType))
    default:
      return .none
    }
  case let .myInfoView(myInfoAction):
    switch myInfoAction {
    case let .movingAction(dismissType):
      if dismissType == .logout {
        return Effect(value: .logout)
      } else if dismissType == .withdrawal {
        return Effect(value: .withdrawal)
      }
      return .none
    default:
      return .none
    }
  case .noticeView:
    return .none
    
  case .withdrawal:
    return environment.appService.userService
      .deleteUser()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .fireAndForget()
  case .dismissToast:
    state.toastPresented = false
    return .none
  }
}
