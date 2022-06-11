//
//  LetterSendCore.swift
//  TiquiTaca_iOS
//
//  Created by hakyung on 2022/06/10.
//

import ComposableArchitecture
import TTNetworkModule

struct LetterSendState: Equatable {
  var sendingUser: UserEntity.Response?
  var inputLetterString: String = ""
  var popupPresented: Bool = false
  var popupType: PopupType = .sendLetter
  var sendLetterSuccess = false
  
  enum PopupType {
    case sendLetter
    case sendLetterError
  }
}

enum LetterSendAction: Equatable {
  case inputLetterTyping(String)
  case sendLetter
  case sendLetterResponse(Result<LetterEntity.Response?, HTTPError>)
  case presentPopup
  case dismissPopup
}

struct LetterSendEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let letterSendReducer = Reducer<
  LetterSendState,
  LetterSendAction,
  LetterSendEnvironment
> { state, action, environment in
  switch action {
  case let .inputLetterTyping(inputText):
    state.inputLetterString = inputText
    return .none
  case .sendLetter:
    let request = LetterEntity.Request(
      message: state.inputLetterString
    )
    
    return environment.appService.letterService
      .sendLetter(userId: state.sendingUser?.id ?? "", request)
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(LetterSendAction.sendLetterResponse)
  case let .sendLetterResponse(.success(response)):
    state.sendLetterSuccess = true
    return Effect(value: .dismissPopup)
  case .sendLetterResponse(.failure):
    return .none
  case .presentPopup:
    state.popupPresented = true
    return .none
  case .dismissPopup:
    state.popupPresented = false
    return .none
  }
}
