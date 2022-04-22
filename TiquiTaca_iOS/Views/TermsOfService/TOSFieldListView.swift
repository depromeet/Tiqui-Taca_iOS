//
//  TOSFieldListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/20.
//

import SwiftUI
import ComposableArchitecture

struct TermsOfService: Equatable, Identifiable {
  let id: UUID = .init()
  let description: String
  let isRequired: Bool
  let url: URL?
  var isChecked: Bool = false
}

struct TOSFieldListView: View {
  let store: Store<TOSFieldListViewState, TOSFieldListViewAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 19) {
        ForEach(viewStore.termsOfServiceModels) { model in
          HStack(alignment: .center, spacing: 12) {
            Button {
              viewStore.send(.check(model.id))
            } label: {
              if model.isChecked {
                Image(systemName: "checkmark.circle.fill")
              } else {
                Image(systemName: "checkmark.circle")
              }
            }
            
            HStack(alignment: .center, spacing: 0) {
              Text(model.isRequired ? "[필수]" : "[선택]")
              Text(model.description)
            }
            
            Spacer()
            
            Button {
              viewStore.send(.selectDetail)
            } label: {
              Text("보기")
                .underline()
            }
            .sheet(
              isPresented: viewStore.binding(
                get: \.isDetailPresented,
                send: TOSFieldListViewAction.dismissTOSDetail
              )
            ) {
              WebView(url: model.url)
            }
          }
          .font(.system(size: 13))
        }
      }
    }
  }
}

struct TOSFieldListView_Previews: PreviewProvider {
  static var previews: some View {
    TOSFieldListView(
      store: Store(
        initialState: TOSFieldListViewState(
          termsOfServiceModels: [
            .init(description: "서비스 이용약관 동의", isRequired: true, url: nil),
            .init(description: "개인정보 수집 및 이용 동의", isRequired: true, url: nil),
            .init(description: "마케팅 SNS 알림 동의", isRequired: false, url: nil)
          ]
        ),
        reducer: tosFieldListViewReducer,
        environment: TOSFieldListViewEnvironment()
      )
    )
  }
}
