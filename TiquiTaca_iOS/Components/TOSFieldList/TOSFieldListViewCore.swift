//
//  TOSFieldListViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/22.
//

import ComposableArchitecture

struct TOSFieldListViewState: Equatable {
  var termsOfServiceModels: [TermsOfService] = [
    .init(description: "서비스 이용약관 동의", isRequired: true, url: URL(string: "https://developer.apple.com/kr/")),
    .init(description: "개인정보 수집 및 이용 동의", isRequired: true, url: nil),
    .init(description: "마케팅 SNS 알림 동의", isRequired: false, url: nil)
  ]
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

let tosFieldListViewReducer = Reducer<
  TOSFieldListViewState,
  TOSFieldListViewAction,
  Void
> { state, action, _ in
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
