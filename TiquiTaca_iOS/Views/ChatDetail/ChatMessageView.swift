//
//  ChatMessageView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/22.
//

import SwiftUI
import TTDesignSystemModule
import ComposableArchitecture


enum ChatMessageType {
  case date
  case sent
  case receive
}

struct ChatMessageView: View {
  let chatLog: ChatLogEntity.Response
  let isBlind: Bool
  let isProfileShow: Bool
  let isTimeShow: Bool
  let profileTapped: ((ChatLogEntity.Response) -> Void)?
  
  init(
    chatLog: ChatLogEntity.Response,
    isBlind: Bool = false,
    isProfileShow: Bool = true,
    isTimeShow: Bool = true,
    profileTapped: ((ChatLogEntity.Response) -> Void)? = nil
  ) {
    self.chatLog = chatLog
    self.profileTapped = profileTapped
    self.isBlind = isBlind
    self.isProfileShow = isProfileShow
    self.isTimeShow = isTimeShow
  }
  
  var body: some View {
    dateBubble
  }
}

extension ChatMessageView {
  var dateBubble: some View {
    VStack(alignment: .center) {
      Spacer()
      Text(chatLog.getMessage())
        .font(.body4)
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
        .background(Color.black100.opacity(0.2))
        .foregroundColor(.white)
        .cornerRadius(16)
      Spacer()
    }
      .padding(.vertical, 4)
      .frame(maxWidth: .infinity)
  }
  
  var sentBubble: some View {
    HStack(alignment: .bottom) {
      Spacer()
      Text(chatLog.createdAt?.getTimeStringFromDateString() ?? "00:00")
        .font(.cap2)
        .foregroundColor(.white900)
        .opacity(isTimeShow ? 1 : 0)
      
      if chatLog.type == 0 {
        HStack(alignment: .top) {
          Text(chatLog.message ?? "잘못된 메세지 입니다")
            .font(.body4)
        }
        .padding([.top, .bottom], 9)
        .padding([.leading, .trailing], 14)
        .background(Color.green500)
        .cornerRadius(14, corners: [.topLeft, .bottomLeft, .bottomRight])
      } else {
        HStack(alignment: .top) {
          Text("질문")
            .font(.body4)
            .foregroundColor(.green500)
            .padding(.top, 2)
          
          Text(chatLog.message ?? "")
            .font(.body4)
            .foregroundColor(Color.white)
            .padding(.top, 2)
          
          HStack(alignment: .bottom, spacing: 0) {
            VStack {
              Spacer().frame(maxWidth: 0.1)
            }
            Image("reply")
          }
        }
          .padding([.top, .bottom], 8)
          .padding([.leading, .trailing], 14)
          .background(Color.black)
          .cornerRadius(14, corners: [.topLeft, .bottomLeft, .bottomRight])
      }
    }
      .padding(.trailing, 10)
      .padding(.leading, 20)
      .padding(.vertical, 2)
  }
  
  var receivedBubble: some View {
    HStack(alignment: .top) {
      ZStack(alignment: .center) {
        Image("chatflagBackground")
          .resizable()
          .frame(width: 32, height: 32)
          .opacity(chatLog.inside == true ? 1 : 0)
        Image(chatLog.sender?.profile.imageName ?? "defaultProfile")
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
      .onTapGesture {
        profileTapped?(chatLog)
      }
      .opacity(isProfileShow ? 1 : 0)
      
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 4) {
          if isProfileShow {
            Text(getName())
              .font(.body7)
              .foregroundColor(.white900)
          }
          
          HStack(alignment: .bottom) {
            HStack(alignment: .top) {
              if chatLog.type == 1 {
                Text("질문")
                  .font(.body4)
                  .foregroundColor(.green500)
                  .padding(.top, 2)
              }
              
              Text(getMessage())
                .font(.body4)
                .foregroundColor(getMessageColor())
                .padding(.top, 2)
              
              if chatLog.type == 1 {
                HStack(alignment: .bottom, spacing: 0) {
                  VStack {
                    Spacer().frame(maxWidth: 0.1)
                  }
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
            
            Text(chatLog.createdAt?.getTimeStringFromDateString() ?? "00:00")
              .font(.cap2)
              .foregroundColor(.white900)
              .opacity(isTimeShow ? 1 : 0)
          }
        }
      }
      
      Spacer()
    }
      .padding(.horizontal, 12)
      .padding(.top, 4)
      .padding(.bottom, isTimeShow ? 4 : 0)
  }
  
  private func getName() -> String {
    if isBlind {
      return chatLog.sender?.status == .forbidden ?
        "(이용제한 사용자)" :
        "(차단된 사용자)"
    } else {
      return chatLog.sender?.nickname ?? "익명"
    }
  }
  
  private func getMessage() -> String {
    if isBlind {
      return chatLog.sender?.status == .forbidden ?
        chatLog.getMessage() :
        "차단된 사용자의 메세지입니다."
    } else {
      return chatLog.getMessage()
    }
  }
  
  private func getMessageColor() -> Color {
    chatLog.type == 1 ?
      (isBlind ? Color.black200 : Color.white) :
      (isBlind ? Color.white700 : Color.black)
  }
}

struct ChatMessageView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMessageView(chatLog: .init())
      .receivedBubble
  }
}
