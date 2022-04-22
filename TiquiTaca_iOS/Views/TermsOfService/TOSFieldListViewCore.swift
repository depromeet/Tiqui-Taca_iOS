//
//  TOSFieldListViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/22.
//

import ComposableArchitecture

struct TOSFieldListViewState: Equatable {
  var termsOfServiceModels: [TermsOfService]
//  var selectedURL: URL? = nil
  var isDetailPresented = false
  var isAllCheckDone = false
}

enum TOSFieldListViewAction: Equatable {
  case selectDetail
  case dismissTOSDetail
  case check(UUID)
  case allCheck
//  case checkAllDone
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
    
    let requiredCount = state.termsOfServiceModels.filter { $0.isRequired }
    let checkCount = state.termsOfServiceModels.filter { $0.isRequired && $0.isChecked }
    state.isAllCheckDone = requiredCount == checkCount
    return .none
  case .allCheck:
    state.termsOfServiceModels = state.termsOfServiceModels.map {
      var model = $0
      if !$0.isChecked {
        model.isChecked.toggle()
      }
      return model
    }
    let requiredCount = state.termsOfServiceModels.filter { $0.isRequired }
    let checkCount = state.termsOfServiceModels.filter { $0.isRequired && $0.isChecked }
    state.isAllCheckDone = requiredCount == checkCount
    return .none
  }
}
