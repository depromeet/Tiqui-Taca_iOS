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
  let store: Store<MyTermsOfServiceState, MyTermsOfServiceAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Text("이용약관")
            .font(.H1)
            .foregroundColor(.black800)
          
          Spacer()
          
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image("idelete")
          }
        }
        .padding(EdgeInsets(top: 28, leading: .spacing24, bottom: 22, trailing: .spacing24))
        
        Text("티키타카 서비스 이용을 위한 약관 모음")
          .font(.B2)
          .foregroundColor(.white800)
          .padding(.leading, .spacing24)
        
        List {
          ForEach(0..<4) {
            MyTermsRow(title: "티키타카 이용약관 \($0 + 1)")
          }
          .listRowBackground(Color.white50)
        }
        .padding(.spacing24)
        .listStyle(.plain)
      }
    }
  }
}

struct MyTermsRow: View {
  var title: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.B1)
        .foregroundColor(.black900)
      Spacer()
      Image("arrow")
    }
    .background(Color.white50)
  }
}

struct MyTermsOfServiceView_Previews: PreviewProvider {
  static var previews: some View {
    MyTermsOfServiceView(store: .init(
      initialState: MyTermsOfServiceState(),
      reducer: myTermsOfServiceReducer,
      environment: MyTermsOfServiceEnvironment())
    )
  }
}
