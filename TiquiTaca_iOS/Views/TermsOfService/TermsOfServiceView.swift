//
//  TermsOfServiceView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/17.
//

import SwiftUI
import ComposableArchitecture

struct TermsOfServiceView: View {
  typealias State = TermsOfServiceState
  typealias Action = TermsOfServiceAction
  
  let store: Store<State, Action>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack(alignment: .center, spacing: 44) {
          LazyVStack(alignment: .leading, spacing: 16) {
            Image(systemName: "questionmark.app.fill")
              .resizable()
              .frame(width: 58, height: 58)
            Text("티키타카가 처음이시네요\n이용약관에 동의해주세요!")
              .font(.system(size: 24))
            Text("원활한 서비스 이용을 위해 이용 약관 및 개인정보와 위치 정보 수집 동의가 필요해요.")
              .font(.system(size: 11))
          }
          .frame(alignment: .leading)
          
          Button {
            viewStore.send(.tosFieldListView(.allCheck))
          } label: {
            HStack {
              Image(systemName: "checkmark.circle.fill")
              Text("전체 동의하기")
                .font(.system(size: 16, weight: .bold, design: .default))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)
            .foregroundColor(Color.white)
            .background(Color.gray)
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 1)
            )
          }
          
          TOSFieldListView(
            store: store.scope(
              state: \.tosFieldListView,
              action: TermsOfServiceAction.tosFieldListView
            )
          )
          
          Spacer()
          
          NavigationLink {
            CreateProfileView(
              store: Store(
                initialState: .init(nickname: ""),
                reducer: createProfileReducer,
                environment: .init()
              )
            )
          } label: {
            Button {
              viewStore.send(.agreeAndGetStartedTapped)
            } label: {
              Text("동의하고 시작하기")
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .font(.system(size: 16, weight: .bold, design: .default))
                .cornerRadius(16)
            }
            .disabled(viewStore.tosFieldListView.isAllRequiredCheckDone)
          }
        }
        .padding(.leading, 23)
        .padding(.trailing, 23)
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}


struct TermsOfServiceView_Previews: PreviewProvider {
  static var previews: some View {
    TermsOfServiceView(
      store: Store(
        initialState: TermsOfServiceState(),
        reducer: termsOfServiceReducer,
        environment: TermsOfServiceEnvironment()
      )
    )
  }
}
