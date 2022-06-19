//
//  ChangeProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule
import ExytePopupView

struct ChangeProfileView: View {
  typealias State = ChangeProfileState
  typealias Action = ChangeProfileAction
  
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
    let changedNickname: String
    let profileImage: ProfileImage
    let bottomSheetPosition: TTBottomSheet.MiddlePosition
    let nicknameError: NicknameError
    let isAvailableCompletion: Bool
    let popupPresented: Bool
    let dismissCurrentPage: Bool
    
    init(state: State) {
      nickname = state.nickname
      changedNickname = state.changedNickname
      profileImage = state.profileImage
      bottomSheetPosition = state.bottomSheetPosition
      nicknameError = state.nicknameError
      isAvailableCompletion = state.isAvailableCompletion
      popupPresented = state.popupPresented
      dismissCurrentPage = state.dismissCurrentPage
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
                get: \.changedNickname,
                send: ChangeProfileAction.nicknameChanged
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
    }
    .fullScreenCover(isPresented: viewStore.binding(
      get: \.popupPresented,
      send: ChangeProfileAction.dismissPopup)
    ) {
      AlertView(isPopupPresent: viewStore.binding(
        get: \.popupPresented,
        send: ChangeProfileAction.dismissPopup))
      .background(BackgroundTransparentView())
    }
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
          send: ChangeProfileAction.setProfileImage
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
        Text("프로필 수정하기")
          .font(.subtitle2)
          .foregroundColor(.white200)
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          viewStore.send(.doneButtonTapped)
          UIView.setAnimationsEnabled(false)
        } label: {
          Text("완료")
            .foregroundColor(.green500)
            .font(.subtitle1)
        }
        .onChange(of: viewStore.dismissCurrentPage) { isDismissCurrentView in
          if isDismissCurrentView {
            presentationMode.wrappedValue.dismiss()
          }
        }
        .disabled(!viewStore.isAvailableCompletion)
      }
    }
    .onTapGesture {
      focusField = false
      viewStore.send(.setBottomSheetPosition(.hidden))
    }
  }
}

private struct AlertView: View {
  @Binding var isPopupPresent: Bool
  
  var body: some View {
    TTPopupView.init(
      popUpCase: .twoLineOneButton,
      title: "앗, 닉네임을 바꿀 수 없어요!",
      subtitle: "현재 참여중인 채팅방을 나오면 닉네임을 바꿀 수 있어요.",
      leftButtonName: "닫기",
      cancel: {
        isPopupPresent = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.setAnimationsEnabled(true)
        }
      }
    )
    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
  }
}

// MARK: - Preview
struct ChangeProfileView_Previews: PreviewProvider {
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
