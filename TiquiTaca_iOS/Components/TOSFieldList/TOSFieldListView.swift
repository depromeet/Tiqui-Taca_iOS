//
//  TOSFieldListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/20.
//

import SwiftUI
import ComposableArchitecture

struct TOSFieldListView: View {
  let store: Store<TOSFieldListViewState, TOSFieldListViewAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        ForEach(viewStore.termsOfServiceModels) { model in
          HStack(spacing: .spacingXXS) {
            Button {
              viewStore.send(.check(model.id))
            } label: {
              if model.isChecked {
                Image("checkFill")
              } else {
                Image("check")
              }
            }
            
            HStack(spacing: 0) {
              Text(model.isRequired ? "[필수] " : "[선택] ")
              Text(model.description)
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Button {
              viewStore.send(.selectDetail(model))
            } label: {
              Text("보기")
                .foregroundColor(.white800)
            }
            .sheet(
              item: viewStore.binding(
                get: \.selectedTermsOfServiceModels,
                send: TOSFieldListViewAction.setSelectedTermsOfServiceModels
              ),
              content: {
                WebView(url: $0.url)
              })
//            .sheet(
//              isPresented: viewStore.binding(
//                get: \.isDetailPresented,
//                send: TOSFieldListViewAction.dismissTOSDetail
//              )
//            ) {
//              WebView(url: model.url)
//            }
          }
          .font(.body4)
          .padding(.vertical, .spacingS)
        }
      }
    }
  }
}

struct TOSFieldListView_Previews: PreviewProvider {
  static var previews: some View {
    TOSFieldListView(
      store: Store(
        initialState: TOSFieldListViewState(),
        reducer: tosFieldListViewReducer,
        environment: Void()
      )
    )
  }
}
