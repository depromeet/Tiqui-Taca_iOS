////
////  OtherProfileCore.swift
////  TiquiTaca_iOS
////
////  Created by 김록원 on 2022/06/07.
////
//
//import Combine
//import ComposableArchitecture
//import TTNetworkModule
//
//struct OtherProfileState: Equatable {
//}
//
//enum OtherProfileAction: Equatable {
//}
//
//struct OtherProfileEnvironment {
//  let appService: AppService
//  let mainQueue: AnySchedulerOf<DispatchQueue>
//}
//
//let otherProfileReducer = Reducer<
//  OtherProfileState,
//  OtherProfileAction,
//  OtherProfileEnvironment
//>.combine([
//  chatMenuReducer
//    .pullback(
//      state: \.chatMenuState,
//      action: /ChatDetailAction.chatMenuAction,
//      environment: {
//        ChatMenuEnvironment(
//          appService: $0.appService,
//          mainQueue: $0.mainQueue
//        )
//      }
//    ),
//  chatDetailCore
//])
//
//let chatDetailCore = Reducer<
//  ChatDetailState,
//  ChatDetailAction,
//  ChatDetailEnvironment
//> { state, action, environment in
//  switch action {
//  case .onAppear:
//    state.moveToOtherView = false
//    
//    guard state.isFirstLoad else { return .none }
//    state.myInfo = environment.appService.userService.myProfile
//    state.chatMenuState = ChatMenuState(roomInfo: state.currentRoom)
//    state.isFirstLoad = false
//    return .merge(
//      Effect(value: .joinRoom),
//      environment.appService.socketService
//        .connect(state.currentRoom.id ?? "")
//        .receive(on: environment.mainQueue)
//        .map(ChatDetailAction.socket)
//        .eraseToEffect()
//        .cancellable(id: ChatDetailId()),
//      environment.locationManager
//        .delegate()
//        .map(ChatDetailAction.locationManager)
//    )
//  case .onDisAppear:
//    guard !state.moveToOtherView else { return .none }
//    return environment.appService.socketService
//      .disconnect(state.currentRoom.id ?? "")
//      .eraseToEffect()
//      .fireAndForget()
//  case let .sendMessage(chat):
//    print("send Message")
//    return environment.appService.socketService
//      .send(state.currentRoom.id ?? "", chat)
//      .eraseToEffect()
//      .map(ChatDetailAction.sendResponse)
//  case let .socket(.initialMessages(messages)):
//    state.chatLogList = messages
//    return .none
//  case let .socket(.newMessage(message)):
//    state.chatLogList.append(message)
//    state.receiveNewChat.toggle()
//    return .none
//  case .joinRoom:
//    return environment.appService.roomService
//      .joinRoom(roomId: state.currentRoom.id ?? "")
//      .receive(on: environment.mainQueue)
//      .catchToEffect()
//      .map(ChatDetailAction.enteredRoom)
//  case let .enteredRoom(.success(res)):
//    return .none
//  case .moveToOtherView:
//    state.moveToOtherView = true
//    return .none
//  case .enteredRoom(.failure):
//    return .none
//  case let .locationManager(.didUpdateLocations(locations)):
//    print("로케이션 받아옴", locations.first?.coordinate.latitude, locations.first?.coordinate.longitude)
//    return .none
//  default:
//    return .none
//  }
//}
