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
      VStack {
        Image(viewStore.characterImage)
          .overlay(
            Button {
              viewStore.send(.editButtonTapped)
            } label: {
              Image("edit")
                .font(.title)
            }
              .padding()
              .alignmentGuide(.bottom) { $0[.bottom] }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
          )
        
        TTBottomSheetView(
          isOpen: viewStore.binding(
            get: \.isSheetPresented,
            send: ProfileCharacterAction.dismissProfileDetail
          ),
          maxHeight: 294,
          content: {
            let gridItemLayout = [
              GridItem(),
              GridItem(),
              GridItem(),
              GridItem()
            ]
            ScrollView {
              VStack(alignment: .leading) {
                Text("프로필 캐릭터")
                  .foregroundColor(Color.TTColor.white)
                  .padding(EdgeInsets(top: 0, leading: 32, bottom: 9, trailing: 0))
                
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                  ForEach(0..<30, id: \.self) { num in
                    Button {
                      viewStore.send(.characterImageChanged(String(num)))
                    } label: {
                      Image("profileFocusRectangle")
                        .frame(width: 84, height: 84)
                        .opacity(String(num) == viewStore.characterImage ? 1 : 0)
                        .overlay(
                          Image("defaultProfile")
                            .resizable()
                            .frame(width: 72, height: 72)
                        )
                    }
                  }
                }
                .padding([.leading, .trailing], 25)
              }
            }
            .background(Color.TTColor.black700)
          })
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
