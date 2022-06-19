//
//  DeeplinkService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/15.
//

import Combine
import ComposableArchitecture

enum DeeplinkType: String {
  /// 질문
  case questionDetail = "/question-detail"
  /// 쪽지
  case letter = "/letter-room"
  /// 채팅방
  case chatRoom = "/chat-room"
  /// 화면 타입
  case screenType = "/screen-type"
}

final class DeeplinkManager {
  enum Action: Equatable {
    case didChangeNavigation(DeeplinkType, [URLQueryItem])
  }
  
  static let shared = DeeplinkManager()
  private var handler: DeeplinkHandler?
  var handling: () -> Effect<Action, Never> = { .none }
  var previousDeeplink: URLComponents?
  var isFirstLaunch: Bool = true {
    didSet {
      if !isFirstLaunch, let url = previousDeeplink {
        handler?.proccessDeeplink(with: url)
      }
    }
  }
  
  private init() {
    let handling = Effect<Action, Never>.run { subscriber in
      let handler = DeeplinkHandler(subscriber)
      self.handler = handler
      return AnyCancellable {
        _ = handler
      }
    }
    .share()
    .eraseToEffect()
    
    self.handling = { handling }
  }
  
  func handleDeeplink(with urlString: String) {
    guard let components = URLComponents(string: urlString) else { return }
    previousDeeplink = components
    
    if components.host == "navigation" {
      handler?.proccessDeeplink(with: components)
    }
  }
}

private class DeeplinkHandler {
  private let subscriber: Effect<DeeplinkManager.Action, Never>.Subscriber
  
  init(_ subscriber: Effect<DeeplinkManager.Action, Never>.Subscriber) {
    self.subscriber = subscriber
  }
  
  func proccessDeeplink(with url: URLComponents) {
    guard let type = DeeplinkType(rawValue: url.path) else { return }
    let items = url.queryItems ?? []
    
    switch type {
    case .questionDetail:
      subscriber.send(.didChangeNavigation(.questionDetail, items))
      
    case .letter:
      subscriber.send(.didChangeNavigation(.letter, items))
      
    case .chatRoom:
      subscriber.send(.didChangeNavigation(.chatRoom, items))
      
    case .screenType:
      subscriber.send(.didChangeNavigation(.screenType, items))
    }
  }
}
