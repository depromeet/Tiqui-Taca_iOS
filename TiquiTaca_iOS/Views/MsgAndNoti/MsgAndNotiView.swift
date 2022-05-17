//
//  MsgAndNotiView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/04/24.
//

import SwiftUI
import ComposableArchitecture

struct MsgAndNotiView: View {
  let store: Store<MsgAndNotiState, MsgAndNotiAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Button {
            viewStore.send(.selectTab(0))
          } label: {
            Text("쪽지함")
              .font(.heading1)
              .foregroundColor(viewStore.selectedTab == 0 ? .black800 : .white800)
          }
          
          Button {
            viewStore.send(.selectTab(1))
          } label: {
            Text("알림")
              .font(.heading1)
              .foregroundColor(viewStore.selectedTab == 1 ? .black800 : .white800)
          }
        }
        .padding(EdgeInsets(top: 28, leading: .spacingXL, bottom: 22, trailing: .spacingXL))
        
        List(viewStore.letterList, id: \.self) { letter in
          LetterRow()
        }
        .padding(.spacingXL)
        .listStyle(.plain)
        .overlay(
          VStack {
            Image(viewStore.selectedTab == 0 ? "letter_g" : "noti_g")
            Text("앗! 아직 다른 사람들과 주고 받은 쪽지가 없어요!")
              .font(.body2)
              .foregroundColor(.white900)
          }
            .opacity(viewStore.letterList.isEmpty ? 1 : 0)
        )
      }
    }
  }
}
  
struct LetterRow: View {
//  var notice: Notice
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("보낸사람")
        .font(.body1)
        .foregroundColor(.black900)
        .padding(.bottom, .spacingXXXS)
      
      HStack {
        Text("보낸날짜")
          .font(.body7)
          .foregroundColor(.black100)
        
        Spacer()
        
        Text("내용")
          .font(.body7)
          .foregroundColor(.white800)
      }
    }
  }
}

struct MsgAndNotiView_Previews: PreviewProvider {
  static var previews: some View {
    MsgAndNotiView(
      store: .init(
        initialState: MsgAndNotiState(),
        reducer: msgAndNotiReducer,
        environment: MsgAndNotiEnvironment(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
