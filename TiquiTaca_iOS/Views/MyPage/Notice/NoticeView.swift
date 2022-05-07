//
//  NoticeView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import SwiftUI
import ComposableArchitecture

struct NoticeView: View {
  let store: Store<NoticeState, NoticeAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Text("공지사항")
          Spacer()
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image("idelete")
          }
        }
        .padding(EdgeInsets(top: 28, leading: .spacing24, bottom: 22, trailing: .spacing24))
        
        List(viewStore.noticeList) { notice in
          NoticeRow(notice: notice)
        }
        .padding(.spacing24)
        .listStyle(.plain)
        .overlay(
          VStack{
            Image("noNotice")
            Text("곧 공지사항이 추가될 예정이에요!")
              .foregroundColor(.white900)
          }
            .opacity(viewStore.noticeList.isEmpty ? 1 : 0)
        )
      }
    }
  }
}

struct NoticeRow: View {
  var notice: Notice
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(notice.title)
        .padding(.bottom, .spacing2)
      
      HStack {
        Text(notice.writer)
          .foregroundColor(.black100)
        
        Spacer()
        
        Text(notice.date)
          .foregroundColor(.white800)
      }
    }
  }
}

struct NoticeView_Previews: PreviewProvider {
  static var previews: some View {
    NoticeView(store: .init(
      initialState: NoticeState(),
      reducer: noticeReducer,
      environment: NoticeEnvironment())
    )
  }
}