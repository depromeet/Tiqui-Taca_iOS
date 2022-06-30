//
//  MyTermsOfServiceView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct MyTermsOfServiceView: View {
  @Environment(\.presentationMode) var presentationMode

  let termsOfServiceUrl = "https://easy-carpenter-187.notion.site/3373d58a140d4c2580a434d2146d175b"
  let privacyPolicyUrl = "https://easy-carpenter-187.notion.site/6775def4caab4230a0d9b71a352b95c3"
  let locationPolicyUrl = "https://easy-carpenter-187.notion.site/126cd4ea8de0432aa280b396dd777b0f"
  let marketingPolicyUrl = "https://easy-carpenter-187.notion.site/3f944748254e4d5e8cb8cff4c8170c4e"
  
  @State var termItem: TermsItem?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("이용약관")
          .font(.heading1)
          .foregroundColor(.black800)
        
        Spacer()
        
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("idelete")
            .resizable()
            .frame(width: 24, height: 24)
        }
      }
      .padding(EdgeInsets(top: 28, leading: .spacingXL, bottom: 22, trailing: .spacingXL))
      
      Text("티키타카 서비스 이용을 위한 약관 모음")
        .font(.body2)
        .foregroundColor(.white800)
        .padding([.leading, .trailing], .spacingXL)
        .padding([.bottom], 22)
      
      Button {
        termItem = TermsItem(url: termsOfServiceUrl)
      } label: {
        MyTermsRow(title: "이용약관")
      }
      
      Button {
        termItem = TermsItem(url: privacyPolicyUrl)
      } label: {
        MyTermsRow(title: "개인정보 처리방침")
      }
      
      Button {
        termItem = TermsItem(url: locationPolicyUrl)
      } label: {
        MyTermsRow(title: "위치정보 수집 및 이용약관")
      }
      
      Button {
        termItem = TermsItem(url: marketingPolicyUrl)
      } label: {
        MyTermsRow(title: "마케팅 정보 활용 약관")
      }
      
      Spacer()
    }
    .background(Color.white)
    .sheet(
      item: $termItem,
      content: {
        WebView(url: URL(string: $0.url))
      }
    )
  }
}

struct TermsItem: Identifiable {
    let id = UUID()
    let url: String
}

struct MyTermsRow: View {
  var title: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.body1)
        .foregroundColor(.black900)
      Spacer()
      Image("arrow")
    }
    .padding(.spacingXL)
    .frame(height: 48)
    .background(Color.white50)
  }
}

struct MyTermsOfServiceView_Previews: PreviewProvider {
  static var previews: some View {
    MyTermsOfServiceView()
  }
}
