//
//  LetterCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import ComposableArchitecture

struct LetterState: Equatable {
}

struct LetterAction: Equatable {
}

struct LetterEnvironment {
  let appService: AppService
  let mainQueue: AnySchedulerOf<DispatchQueue>
}

let letterReducer = Reducer<
  LetterState,
  LetterAction,
  LetterEnvironment
>.combine([
  letterCore
])

private let letterCore = Reducer<
  LetterState,
  LetterAction,
  LetterEnvironment
> { state, action, environment in
  switch action {
  default:
    return .none
  }
}
