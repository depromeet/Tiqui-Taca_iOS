//
//  ProfileCharacterView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ProfileCharacterView: View {
  let store: Store<ProfileCharacterState, ProfileCharacterAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Image(viewStore.characterImage)
          .overlay(
            Button(action: {
              viewStore.send(.editButtonTapped)
            })
            {
              Image("edit")
                .font(.title)
            }
              .sheet(
                isPresented:
                  viewStore.binding(
                    get: \.isSheetPresented,
                    send: ProfileCharacterAction.dismissProfileDetail
                  )
              ) {
                
              }
              .padding()
              .alignmentGuide(.bottom) { $0[.bottom] }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
          )
        
        TTBottomSheetView (
          isOpen: .constant(viewStore.isSheetPresented),
          maxHeight: 294,
          content: {
            let gridItemLayout = [
              GridItem(),
              GridItem(),
              GridItem(),
              GridItem()
            ]
            ScrollView {
              LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(0..<30, id: \.self) { _ in
                  Image("defaultProfile")
                    .resizable()
                    .frame(width: 72, height: 72)
                }
              }
            }
            .background(Color.TTColor.black700)
          })
        .ignoresSafeArea()
      }
    }
  }
}

struct ProfileCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileCharacterView(
      store: Store(
        initialState: .init(characterImage: "defaultProfile"),
        reducer: profileCharacterReducer,
        environment: .init()
      )
    )
  }
}
