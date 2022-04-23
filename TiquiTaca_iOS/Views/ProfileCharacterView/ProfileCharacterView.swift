//
//  ProfileCharacterView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct ProfileCharacterView: View {
  let store: Store<ProfileCharacterState, ProfileCharacterAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Image(viewStore.characterImage)
      }
      .background(Color(viewStore.backgroundColor))
    }
  }
}

struct ProfileCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileCharacterView(
      store: Store(
        initialState: .init(backgroundColor: "", characterImage: ""),
        reducer: profileCharacterReducer,
        environment: .init()
      )
    )
  }
}
