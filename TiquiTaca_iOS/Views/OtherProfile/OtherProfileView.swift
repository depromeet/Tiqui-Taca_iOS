//
//  OtherProfileView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/06/07.
//

import SwiftUI
import TTDesignSystemModule

struct OtherProfileView: View {
  @Binding var showProfile: Bool
  @State var showPopup: Bool = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Color.black800.opacity(0.7)
    }
    .edgesIgnoringSafeArea(.all)
    .fullScreenCover(isPresented: $showProfile) {
      ZStack(alignment: .bottom) {
        Color.clear
        VStack(spacing: 0) {
          HStack(spacing: 32) {
            Button {
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
                Text("차단")
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
                Text("차단")
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
              Image("character18")
                .resizable()
                .frame(width: 104, height: 104)
                .padding(.leading, 1)
                .padding(.top, 2)
            }
            
            HStack(alignment: .center, spacing: 4) {
              Image("bxLoudspeaker3")
                .resizable()
                .frame(width: 32, height: 32)
              Text("디폴트")
                .font(.heading2)
                .foregroundColor(.white)
            }
          }
            .padding(.top, -32)
          ,
          alignment: .top
        )
      }
      
      .edgesIgnoringSafeArea(.all)
      .background(BackgroundClearView().onTapGesture {
        showProfile = false
      })
    }
    .fullScreenCover(isPresented: $showPopup) {
      Text("팝업")
    }
  }
}

//struct OtherProfileView_Previews: PreviewProvider {
//  static var previews: some View {
//    OtherProfileView(showProfile: Binding<Bool>(true))
//  }
//}
