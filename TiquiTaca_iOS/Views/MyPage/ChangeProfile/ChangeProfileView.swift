//
//  ChangeProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ChangeProfileView: View {
  let store: Store<ChangeProfileState, ChangeProfileAction>
  
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
              send: ChangeProfileAction.nicknameChanged
            )
          )
          .foregroundColor(Color.white)
          .disableAutocorrection(true)
          .padding([.leading, .trailing], 40)
          
          Text("프로필 이름과 이미지를 수정해보세요.")
            .foregroundColor(Color.white)
            .font(.caption)
            .multilineTextAlignment(.center)
          
          Spacer()
          
          TTBottomSheetView(
            isOpen: viewStore.binding(
              get: \.isSheetPresented,
              send: ChangeProfileAction.dismissProfileDetail
            ),
            minHeight: 0,
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
                    .foregroundColor(Color.white)
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
              .background(Color.black700)
            })
        }
        .frame(maxHeight: .infinity)
        .background(Color.black800)
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
      .tint(Color.greenTextColor)
      .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    }
  }
}

struct ChangeProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ChangeProfileView(store: .init(
      initialState: ChangeProfileState(),
      reducer: changeProfileReducer,
      environment: ChangeProfileEnvironment())
    )
  }
}
