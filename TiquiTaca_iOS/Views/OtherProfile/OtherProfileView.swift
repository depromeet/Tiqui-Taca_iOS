//
//  OtherProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/07.
//

import Combine
import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct OtherProfileView: View {
  typealias OPState = OtherProfileState
  typealias OPAction = OtherProfileAction
  
  var store: Store<OPState, OPAction>
  @ObservedObject private var viewStore: ViewStore<ViewState, OPAction>
  @Binding var showView: Bool
  @State var showProfile: Bool = false
  @State var showPopup: Bool = false
  
  struct ViewState: Equatable {
    let otherUser: UserEntity.Response?
    init(state: OPState) {
      otherUser = state.otherUser
    }
  }
  
  init(store: Store<OPState, OPAction>, showView: Binding<Bool>) {
    self.store = store
    self._showView = showView
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Color.black800.opacity(0.7)
    }
    .onReceive(Just(showView)) { value in
      showProfile = value
    }
    .edgesIgnoringSafeArea(.all)
    .fullScreenCover(isPresented: $showProfile) {
      ZStack(alignment: .bottom) {
        Color.clear
        VStack(spacing: 0) {
          HStack(spacing: 32) {
            Button {
              showPopup = true
              showProfile = false
            } label: {
              VStack(alignment: .center) {
                Image("profileBlock")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("차단")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
            Button {
            } label: {
              VStack(alignment: .center) {
                Image("report")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("신고")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
            Button {
            } label: {
              VStack(alignment: .center) {
                Image("note")
                  .resizable()
                  .frame(width: 48, height: 48)
                Text("쪽지")
                  .font(.body2)
                  .foregroundColor(.white50)
              }
            }
          }
          .hCenter()
          .padding(.top, 138)
          .padding(.bottom, 24)
          
          Button {
          } label: {
            HStack(spacing: 0) {
              Text("해당 유저에게 번개 주기")
                .font(.subtitle1)
                .foregroundColor(.black900)
              Image("profileSpark")
                .resizable()
                .frame(width: 28, height: 28)
            }
          }
          .buttonStyle(TTButtonLargeGreenStyle())
          .padding(.horizontal, 24)
          
          VStack { }
            .hCenter()
            .frame(height: 44)
        }
        .background(Color.black700)
        .cornerRadius(48, corners: [.topLeft, .topRight])
        .overlay(
          VStack(spacing: 6) {
            ZStack(alignment: .center) {
              Image("profileRectangle")
                .resizable()
                .frame(width: 110, height: 110)
              Image(viewStore.otherUser?.profile.imageName ?? "character18")
                .resizable()
                .frame(width: 104, height: 104)
                .padding(.leading, 1)
                .padding(.top, 2)
            }
            
            HStack(alignment: .center, spacing: 4) {
              Image("bxLoudspeaker3")
                .resizable()
                .frame(width: 32, height: 32)
              Text("\(viewStore.otherUser?.nickname ?? "")")
                .font(.heading2)
                .foregroundColor(.white)
            }
          }
            .padding(.top, -32)
          , alignment: .top
        )
      }
      
      .edgesIgnoringSafeArea(.all)
      .background(BackgroundClearView().onTapGesture {
        print("???")
        showView = false
      })
    }
    .fullScreenCover(isPresented: $showPopup) {
      TTPopupView.init(
        popUpCase: .oneLineTwoButton,
        title: "해당 사용자를\n차단 하시겠습니까?",
        subtitle: "",
        leftButtonName: "취소",
        rightButtonName: "차단하기",
        confirm: {
          showPopup = false
          showView = false
        },
        cancel: {
          showPopup = false
          showView = false
        }
      )
        .padding(.horizontal, 24)
        .background(BackgroundClearView())
    }
  }
}

//struct OtherProfileView_Previews: PreviewProvider {
//  static var previews: some View {
//    OtherProfileView(showProfile: Binding<Bool>(true))
//  }
//}
