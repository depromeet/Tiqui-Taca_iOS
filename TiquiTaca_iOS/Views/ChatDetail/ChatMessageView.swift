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
  typealias State = ChatMessageState
  typealias Action = ChatMessageAction
  
  let store: Store<ChatMessageState, ChatMessageAction>
  
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    var id: String = ""
    var profileImage: String = "defaultProfile"
    var inside: Bool = false
    var receivedType: Int? = 0
    var receivedMessage: String = ""
    var createdAt: String?
    
    var sentMessage: String = ""
    var sentAt: String?
    var sentType: Int? = 0
    
    init(state: State) {
      id = state.id
      profileImage = state.profileImage
      inside = state.inside
      receivedType = state.receivedType
      receivedMessage = state.receivedMessage
      createdAt = state.createdAt
      
      sentMessage = state.sentMessage
      sentAt = state.sentAt
      sentType = state.sentType
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
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
      Text(viewStore.sentAt?.getTimeStringFromDateString() ?? "")
        .font(.cap2)
        .foregroundColor(.white900)
      
      HStack(alignment: .top) {
        if viewStore.sentType != MessageType.text.rawValue {
          Text("질문")
            .font(.body4)
            .foregroundColor(.blue900)
        }
        
        Text(viewStore.sentMessage)
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
          .opacity(viewStore.inside ? 1 : 0)
        
        Image(viewStore.profileImage)
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
          .opacity(viewStore.inside ? 1 : 0)
      )
      
      HStack(alignment: .bottom) {
        VStack(alignment: .leading) {
          Text(viewStore.id)
            .font(.body7)
            .foregroundColor(.white900)
          
          HStack(alignment: .top) {
            if viewStore.receivedType != MessageType.text.rawValue {
              Text("질문")
                .font(.body4)
                .foregroundColor(.green500)
            }
            
            HStack(alignment: .bottom) {
              Text(viewStore.receivedMessage)
                .font(.body4)
                .foregroundColor(viewStore.receivedType == MessageType.text.rawValue ? Color.black : Color.white)
              
              if viewStore.receivedType != MessageType.text.rawValue {
                Image("reply")
              }
            }
          }
          .padding([.top, .bottom], 9)
          .padding([.leading, .trailing], 14)
          .background(
            viewStore.receivedType == MessageType.text.rawValue ? Color.white150 : Color.black
          )
          .cornerRadius(14, corners: [.topRight, .bottomLeft, .bottomRight])
        }
        
        
        Text(viewStore.createdAt?.getTimeStringFromDateString() ?? "")
          .font(.cap2)
          .foregroundColor(.white900)
      }
      
      Spacer()
    }
    .padding(10)
  }
}

struct ChatMessageView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMessageView(
      store: .init(
        initialState: .init(),
        reducer: chatMessageReducer,
        environment: ChatMessageEnvironment()
      )
    )
  }
}
