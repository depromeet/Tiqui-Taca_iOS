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
  
  var validationColor: Color {
    switch viewStore.nicknameError {
    case .none:
      return .white600
    default:
      return .errorRed
    }
  }
  
  struct ViewState: Equatable {
    let nickname: String
    let profileImage: ProfileImage
    let bottomSheetPosition: TTBottomSheet.MiddlePosition
    let nicknameError: NicknameError
    let isAvailableCompletion: Bool
    
    init(state: State) {
      nickname = state.nickname
      profileImage = state.profileImage
      bottomSheetPosition = state.bottomSheetPosition
      nicknameError = state.nicknameError
      isAvailableCompletion = state.isAvailableCompletion
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 29) {
      ZStack(alignment: .bottomTrailing) {
        Image(viewStore.profileImage.imageName)
        Button {
          focusField = false
          viewStore.send(.setBottomSheetPosition(.middle))
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
            .background(validationColor)
        }
        
        Text(viewStore.nicknameError.description)
          .foregroundColor(validationColor)
          .font(.body4)
      }
      .multilineTextAlignment(.center)
      
      Spacer()
    }
    .padding(.horizontal, .spacingXL)
    .padding(.top, 120)
    .vCenter()
    .hCenter()
    .background(Color.black800)
    .ignoresSafeArea(.keyboard)
    .navigationBarBackButtonHidden(true)
    .bottomSheet(
      bottomSheetPosition: viewStore.binding(
        get: \.bottomSheetPosition,
        send: Action.setBottomSheetPosition
      ),
      options: TTBottomSheet.Options
    ) {
      ProfileImageListView(
        selectedProfile: viewStore.binding(
          get: \.profileImage,
          send: CreateProfileAction.setProfileImage
        )
      ).padding(.top, .spacingXXL)
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("leftArrow")
        }
      }
      ToolbarItem(placement: .principal) {
        Text("프로필 만들기")
          .font(.subtitle2)
          .foregroundColor(.white200)
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          viewStore.send(.doneButtonTapped)
        } label: {
          Text("완료")
            .foregroundColor(.green500)
            .font(.subtitle1)
        }
        .disabled(!viewStore.isAvailableCompletion)
      }
    }
    .onTapGesture {
      viewStore.send(.setBottomSheetPosition(.hidden))
      focusField = false
    }
  }
}

// MARK: - Preview
struct CreateProfileView_Previews: PreviewProvider {
  static var previews: some View {
    CreateProfileView(
      store: Store(
        initialState: .init(),
        reducer: createProfileReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
