//
//  TOSFieldListViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/22.
//

import ComposableArchitecture

struct TOSFieldListViewState: Equatable {
  var termsOfServiceModels: [TermsOfService]
  var isDetailPresented = false
  var isAllRequiredCheckDone = false
  var isAllCheckDone = false
}

enum TOSFieldListViewAction: Equatable {
  case selectDetail
  case dismissTOSDetail
  case check(UUID)
  case allCheck
}

struct TOSFieldListViewEnvironment { }

let tosFieldListViewReducer = Reducer<
  TOSFieldListViewState,
  TOSFieldListViewAction,
  TOSFieldListViewEnvironment
> { state, action, environment in
  switch action {
  case .selectDetail:
    state.isDetailPresented = true
    return .none
  case .dismissTOSDetail:
    state.isDetailPresented = false
    return .none
  case .check(let id):
    state.termsOfServiceModels = state.termsOfServiceModels.map {
      var model = $0
      if $0.id == id {
        model.isChecked.toggle()
      }
      return model
    }
    return checkAllDone(&state)
  case .allCheck:
    state.termsOfServiceModels = state.termsOfServiceModels.map {
      var model = $0
      if !$0.isChecked || state.isAllCheckDone {
        model.isChecked.toggle()
      }
      return model
    }
    return checkAllDone(&state)
  }
}

private func checkAllDone(_ state: inout TOSFieldListViewState) -> Effect<TOSFieldListViewAction, Never> {
  let models = state.termsOfServiceModels
  let totalCount = models.count
  let checkCount = models.filter { $0.isChecked }.count
  state.isAllCheckDone = totalCount == checkCount
  
  let requiredCount = models.filter { $0.isRequired }.count
  let checkRequiredCount = models.filter { $0.isRequired && $0.isChecked }.count
  state.isAllRequiredCheckDone = requiredCount == checkRequiredCount
  return .none
}
