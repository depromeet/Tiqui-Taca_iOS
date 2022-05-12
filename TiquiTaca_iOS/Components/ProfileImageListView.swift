//
//  ProfileImageListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/12.
//

import SwiftUI

struct ProfileImageListView: View {
  @Binding var selectedProfile: String
  
  let gridItemLayout: [GridItem] = [
    .init(), .init(), .init(), .init()
  ]
  
  var body: some View {
    VStack(spacing: .spacingS) {
      Text("프로필 캐릭터")
        .foregroundColor(.white)
        .font(.body6)
        .hLeading()
      
      ScrollView {
        LazyVGrid(columns: gridItemLayout, spacing: 6) {
          ForEach(1...30, id: \.self) { index in
            let profileImageName = "profile\(index)"
            let isSelectedProfile = selectedProfile == profileImageName
            
            Button {
              selectedProfile = profileImageName
            } label: {
              ZStack {
                Image("profileFocusRectangle")
                  .resizable()
                  .frame(width: 84, height: 84)
                  .opacity(isSelectedProfile ? 1 : 0)
                Image(profileImageName)
                  .resizable()
                  .frame(width: 72, height: 72)
              }
            }
          }
        }
      }
    }.padding(.horizontal)
  }
}

// MARK: - Preview
struct ProfileImageListView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileImageListView(selectedProfile: .constant("profile1"))
      .background(Color.black700)
  }
}
