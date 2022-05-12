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
  typealias State = CreateProfileState
  typealias Action = CreateProfileAction
  
  private let store: Store<State, Action>
  @FocusState private var focusField: Bool
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode
  
  struct ViewState: Equatable {
    let nickname: String
    let profileImage: String
    let isSheetPresented: Bool
    let nicknameFocused: Bool
    
    init(state: State) {
      nickname = state.nickname
      profileImage = state.profileImage
      isSheetPresented = state.isSheetPresented
      nicknameFocused = state.nicknameFocused
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    ZStack {
      VStack(spacing: 29) {
        ZStack(alignment: .bottomTrailing) {
          Image(viewStore.profileImage)
          Button {
            focusField = false
            viewStore.send(.profileEditButtonTapped)
          } label: {
            Image("edit")
          }
        }
        
        VStack(spacing: .spacingM) {
          VStack(spacing: .spacingXS) {
            TextField(
              "닉네임을 입력해주세요.",
              text: viewStore.binding(
                get: \.nickname,
                send: CreateProfileAction.nicknameChanged
              )
            )
            .padding(.top, .spacingXS)
            .font(.heading2)
            .foregroundColor(Color.white)
            .disableAutocorrection(true)
            .focused($focusField)
            
            Divider()
              .frame(height: 2)
              .background(Color.green500)
          }
          
          Text("티키타카에서 사용할 닉네임과 프로필을 선택해주세요.\n닉네임은 최대 10자까지 입력이 가능해요!")
            .foregroundColor(Color.white)
            .font(.body4)
        }
        .multilineTextAlignment(.center)
        
        Spacer()
      }
      .padding(.horizontal, .spacingXL)
      .padding(.top, 120)
      
      TTBottomSheetView(
        isOpen: viewStore.binding(
          get: \.isSheetPresented,
          send: CreateProfileAction.setBottomSheet
        ),
        minHeight: 0,
        maxHeight: 294,
        content: {
          ProfileImageListView()
            .padding(.top, .spacingXXL)
        }
      )
    }
    .vCenter()
    .hCenter()
    .background(Color.black800)
    .ignoresSafeArea(.keyboard)
    .navigationBarBackButtonHidden(true)
    .navigationTitle("프로필 만들기")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("leftArrow")
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          viewStore.send(.doneButtonTapped)
        } label: {
          Text("완료")
            .foregroundColor(.green500)
            .font(.subtitle1)
        }
      }
    }
    .onTapGesture {
      focusField = false
      viewStore.send(.setBottomSheet(isPresent: false))
    }
  }
}

// MARK: - Preview
struct CreateProfileView_Previews: PreviewProvider {
  static var previews: some View {
    CreateProfileView(
      store: Store(
        initialState: .init(isSheetPresented: true),
        reducer: createProfileReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
