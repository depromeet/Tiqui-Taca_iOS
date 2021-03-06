//
//  NoticeView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/07.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct NoticeView: View {
  let store: Store<NoticeState, NoticeAction>
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {
        HStack {
          Text("공지사항")
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
        
        List(viewStore.noticeList) { notice in
          NoticeRow(notice: notice)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
        }
        .padding(.spacingXL)
        .listStyle(.plain)
        .overlay(
          VStack {
            Image("notice_g")
            Text("곧 공지사항이 추가될 예정이에요!")
              .font(.body2)
              .foregroundColor(.white900)
          }
            .opacity(viewStore.noticeList.isEmpty ? 1 : 0)
        )
      }
      .background(Color.white)
      .onAppear {
        viewStore.send(.getNoticeList)
      }
    }
  }
}

struct NoticeRow: View {
  var notice: OfficialNotiResponse
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(notice.content)
        .font(.body1)
        .foregroundColor(.black900)
        .padding(.bottom, .spacingXXXS)
      
      HStack {
        Text(notice.nickname)
          .font(.body7)
          .foregroundColor(.black100)
        
        Spacer()
        
        Text(notice.createdAt.getYearAndDate().replacingOccurrences(of: "/", with: "."))
          .font(.body5)
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
      environment: NoticeEnvironment(
        appService: AppService(),
        mainQueue: .main)
      )
    )
  }
}
