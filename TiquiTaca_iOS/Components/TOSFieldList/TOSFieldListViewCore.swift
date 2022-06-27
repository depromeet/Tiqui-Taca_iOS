//
//  TOSFieldListViewCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/22.
//

import ComposableArchitecture

struct TOSFieldListViewState: Equatable {
  var termsOfServiceModels: [TermsOfService] = [
    .init(description: "서비스 이용약관 동의", isRequired: true, url: URL(string: "https://easy-carpenter-187.notion.site/3373d58a140d4c2580a434d2146d175b")),
    .init(description: "개인정보 수집 및 이용 동의", isRequired: true, url: URL(string: "https://easy-carpenter-187.notion.site/6775def4caab4230a0d9b71a352b95c3")),
    .init(description: "위치정보 수집 및 이용 동의", isRequired: true, url: URL(string: "https://easy-carpenter-187.notion.site/126cd4ea8de0432aa280b396dd777b0f")),
    .init(description: "마케팅 SNS 알림 동의", isRequired: false, url: URL(string: "https://easy-carpenter-187.notion.site/3f944748254e4d5e8cb8cff4c8170c4e"))
  ]
  
  var selectedTermsOfServiceModels: TermsOfService?
  var isDetailPresented = false
  var isAllRequiredCheckDone = false
  var isAllCheckDone = false
}

enum TOSFieldListViewAction: Equatable {
  case selectDetail(TermsOfService)
  case dismissTOSDetail
  case check(UUID)
  case allCheck
  case setSelectedTermsOfServiceModels(TermsOfService?)
}

let tosFieldListViewReducer = Reducer<
  TOSFieldListViewState,
  TOSFieldListViewAction,
  Void
> { state, action, _ in
  switch action {
  case let .selectDetail(service):
    state.selectedTermsOfServiceModels = service
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
  case let .setSelectedTermsOfServiceModels(service):
    state.selectedTermsOfServiceModels = service
    return .none
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
