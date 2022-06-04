//
//  ChatMessageView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/22.
//

import SwiftUI
import TTDesignSystemModule
import ComposableArchitecture

struct ChatMessageView: View {
  let chatLog: ChatLogEntity.Response
  
  var body: some View {
    VStack {
      receivedBubble
      sentBubble
    }
  }
}

extension ChatMessageView {
  var sentBubble: some View {
    HStack(alignment: .bottom) {
      Spacer()
      Text(chatLog.createdAt?.getTimeStringFromDateString() ?? "00:00")
        .font(.cap2)
        .foregroundColor(.white900)
      
      HStack(alignment: .top) {
        if chatLog.type == 1 {
          Text("질문")
            .font(.body4)
            .foregroundColor(.blue900)
        }
        
        Text(chatLog.message ?? "잘못된 메세지 입니다")
          .font(.body4)
      }
        .padding([.top, .bottom], 9)
        .padding([.leading, .trailing], 14)
        .background(Color.green500)
        .cornerRadius(14, corners: [.topLeft, .bottomLeft, .bottomRight])
    }
    .padding(.trailing, 10)
  }
  
  var receivedBubble: some View {
    HStack(alignment: .top) {
      ZStack(alignment: .center) {
        Image("chatflagBackground")
          .resizable()
          .frame(width: 32, height: 32)
          .opacity(chatLog.inside == true ? 1 : 0)
        
        Image("defaultProfile")
          .resizable()
          .frame(width: 30, height: 30)
          .padding(3)
      }
      .frame(width: 34, height: 35)
      .overlay(
        Image("chatflag")
          .resizable()
          .frame(width: 12, height: 12)
          .alignmentGuide(.bottom) { $0[.bottom] }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
          .opacity(chatLog.inside == true ? 1 : 0)
      )
      
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 4) {
          Text(chatLog.sender?.nickname ?? "익명")
            .font(.body7)
            .foregroundColor(.white900)
          
          HStack(alignment: .top) {
            if chatLog.type == 1 {
              Text("질문")
                .font(.body4)
                .foregroundColor(.green500)
                .padding(.top, 2)
            }
            Text(chatLog.message ?? "")
              .font(.body4)
              .foregroundColor(chatLog.type == 1 ? Color.white : Color.black)
              .padding(.top, 2)
            if chatLog.type == 1 {
              HStack(alignment: .bottom) {
                Image("reply")
              }
            }
          }
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 14)
            .background(
              chatLog.type == 1 ? Color.black : Color.white150
            )
            .cornerRadius(14, corners: [.topRight, .bottomLeft, .bottomRight])
        }
        
        Text(chatLog.createdAt?.getTimeStringFromDateString() ?? "00:00")
          .font(.cap2)
          .foregroundColor(.white900)
      }
      
      Spacer()
    }
      .padding(.horizontal, 12)
      .padding(.vertical, 4)
  }
}

struct ChatMessageView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMessageView(chatLog: .init())
      .receivedBubble
  }
}
