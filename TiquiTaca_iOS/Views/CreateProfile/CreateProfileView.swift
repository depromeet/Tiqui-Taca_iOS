//
//  CreateProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct CreateProfileView: View {
  let store: Store<CreateProfileState, CreateProfileAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
//      NavigationView {
        LazyVStack {
//          ProfileCharacterView()
//          NicknameFieldView()
          Text("티키타카에서 사용할 닉네님과 프로필을 선택해주세요.\n닉네임은 최대 20자까지 입력이 가능해요!")
        }
//        .navigationTitle("프로필 만들기")
//        .toolbar {
//          ToolbarItem(placement: .navigationBarTrailing) {
//            Button {
//              viewStore.send(.doneButtonTapped)
//            } label: {
//              Text("완료")
//            }
//          }
//        }
//      }
    }
  }
}

struct CreateProfileView_Previews: PreviewProvider {
  static var previews: some View {
    CreateProfileView(
      store: Store(
        initialState: .init(nickname: ""),
        reducer: createProfileReducer,
        environment: .init()
      )
    )
  }
}
