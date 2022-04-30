//
//  CreateProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct CreateProfileView: View {
  let store: Store<CreateProfileState, CreateProfileAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        ZStack {
          ProfileCharacterView(
            store: Store(
              initialState: .init(characterImage: "defaultProfile"),
              reducer: profileCharacterReducer,
              environment: .init()
            )
          )
          .padding([.top], 120)
          
          VStack {
            TextField(
              "닉네임을 입력해주세요.",
              text: viewStore.binding(
                get: \.nickname,
                send: CreateProfileAction.nicknameChanged
              )
            )
            .foregroundColor(.white)
            .disableAutocorrection(true)
            .padding([.leading, .trailing], 40)
            
            Text("티키타카에서 사용할 닉네님과 프로필을 선택해주세요.\n닉네임은 최대 20자까지 입력이 가능해요!")
              .foregroundColor(.white)
              .font(.caption)
              .multilineTextAlignment(.center)
          }
        }
        .background(Color.TTColor.black800)
        .ignoresSafeArea(.keyboard)
        .navigationTitle("프로필 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              viewStore.send(.doneButtonTapped)
            } label: {
              Text("완료")
            }
          }
        }
      }
      .tint(Color.TTColor.greenTextColor)
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
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
