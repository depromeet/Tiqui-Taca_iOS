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
        VStack {
          Image(viewStore.profileImage)
            .overlay(
              Button {
                viewStore.send(.profileEditButtonTapped)
              } label: {
                Image("edit")
                  .font(.title)
              }
              .alignmentGuide(.bottom) { $0[.bottom] }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            )
            .padding([.top], 120)
          
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
          
          Text("티키타카에서 사용할 닉네임과 프로필을 선택해주세요.\n닉네임은 최대 20자까지 입력이 가능해요!")
            .foregroundColor(.white)
            .font(.caption)
            .multilineTextAlignment(.center)
          
          Spacer()
          
          TTBottomSheetView(
            isOpen: viewStore.binding(
              get: \.isSheetPresented,
              send: CreateProfileAction.dismissProfileDetail
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
                        viewStore.send(.profileImageChanged(String(num)))
                      } label: {
                        Image("profileFocusRectangle")
                          .frame(width: 84, height: 84)
                          .opacity(String(num) == viewStore.profileImage ? 1 : 0)
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
        .frame(maxHeight: .infinity)
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
        initialState: .init(),
        reducer: createProfileReducer,
        environment: .init()
      )
    )
  }
}
