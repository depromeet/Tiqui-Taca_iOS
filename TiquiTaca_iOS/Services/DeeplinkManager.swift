//
//  DeeplinkService.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/15.
//

import ComposableArchitecture

enum TikiTakaDeeplinkType {
  case questionDetail
  case letter
  case chat
  case lightning
}

final class DeeplinkManager {
  static let shared = DeeplinkManager()
  private init() { }
  
  enum Action: Equatable {
    case didChangeNavigation(TikiTakaDeeplinkType)
  }
  
  var handling: () -> Effect<Action, Never>
  
  func handleDeeplink() {
    
  }
}
