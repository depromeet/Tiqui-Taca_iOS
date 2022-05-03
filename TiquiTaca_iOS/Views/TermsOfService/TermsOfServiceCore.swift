//
//  TermsOfServiceCore.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/20.
//

import ComposableArchitecture

struct TermsOfServiceState: Equatable {
  var tosFieldListView: TOSFieldListViewState = .init(
    termsOfServiceModels: [
      .init(description: "서비스 이용약관 동의", isRequired: true, url: URL(string: "https://developer.apple.com/kr/")),
      .init(description: "개인정보 수집 및 이용 동의", isRequired: true, url: nil),
      .init(description: "마케팅 SNS 알림 동의", isRequired: false, url: nil)
    ]
  )
}

enum TermsOfServiceAction: Equatable {
  case agreeAndGetStartedTapped
  case tosFieldListView(TOSFieldListViewAction)
}

struct TermsOfServiceEnvironment {
}

let termsOfServiceReducer = Reducer<
  TermsOfServiceState,
  TermsOfServiceAction,
  TermsOfServiceEnvironment
>.combine([
  tosFieldListViewReducer
    .pullback(
      state: \.tosFieldListView,
      action: /TermsOfServiceAction.tosFieldListView,
      environment: { _ in
        TOSFieldListViewEnvironment()
      }
    ),
  termsOfServiceReducerCore
])

let termsOfServiceReducerCore = Reducer<
  TermsOfServiceState,
  TermsOfServiceAction,
  TermsOfServiceEnvironment
> { state, action, environment in
  switch action {
  case .agreeAndGetStartedTapped:
    return .none
  case .tosFieldListView:
    return .none
  }
}
