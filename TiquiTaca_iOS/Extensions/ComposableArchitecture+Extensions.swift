//
//  ComposableArchitecture+Extensions.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/07.
//

import ComposableArchitecture

extension Reducer {
  fileprivate func nonCrashingOptional(_ file: StaticString = #file, _ line: UInt = #line) -> Reducer<
    State?, Action, Environment
  > {
    .init { state, action, environment in
      guard state != nil else {
        return .none
      }
      return self.run(&state!, action, environment)
    }
  }
  
  public func presents<LocalState, LocalAction, LocalEnvironment>(
    _ localReducer: Reducer<LocalState, LocalAction, LocalEnvironment>,
    cancelEffectsOnDismiss: Bool,
    state toLocalState: WritableKeyPath<State, LocalState?>,
    action toLocalAction: CasePath<Action, LocalAction>,
    environment toLocalEnvironment: @escaping (Environment) -> LocalEnvironment
  ) -> Self {
    let id = UUID()
    return Self { state, action, environment in
      let hadLocalState = state[keyPath: toLocalState] != nil
      let localEffects = localReducer
        .nonCrashingOptional()
        .pullback(state: toLocalState, action: toLocalAction, environment: toLocalEnvironment)
        .run(&state, action, environment)
        .cancellable(id: id)
      let globalEffects = self.run(&state, action, environment)
      let hasLocalState = state[keyPath: toLocalState] != nil
      return .merge(
        localEffects,
        globalEffects,
        cancelEffectsOnDismiss && hadLocalState && !hasLocalState ? .cancel(id: id) : .none
      )
    }
  }
}
