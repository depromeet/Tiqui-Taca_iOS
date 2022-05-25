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
    var type: Int = 1
    var receivedMessage: String = ""
    var createdAt: Date?
    
    var sentMessage: String = ""
    var sentAt: Date?
    
    init(state: State) {
      id = state.id
      profileImage = state.profileImage
      inside = state.inside
      type = state.type
      receivedMessage = state.receivedMessage
      createdAt = state.createdAt
      
      sentMessage = state.sentMessage
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    receivedBubble
    sentBubble
  }
}

private extension ChatMessageView {
  var sentBubble: some View {
    HStack(alignment: .bottom) {
      Spacer()
      Text("23:00")
        .font(.cap2)
        .foregroundColor(.white900)
      
      Text(viewStore.sentMessage)
        .font(.body4)
        .padding([.top, .bottom], 9)
        .padding([.leading, .trailing], 14)
        .background(Color.green500)
        .cornerRadius(14, corners: [.topLeft, .bottomLeft, .bottomRight])
        .frame(
          minWidth: 10,
          idealWidth: 244,
          maxWidth: 244,
          alignment: .topLeading
        )
    }
//    .padding(.trailing, 10)
  }
  
  var receivedBubble: some View {
    HStack(alignment: .top) {
      ZStack(alignment: .center) {
        Image("insideFlag_b")
          .resizable()
          .frame(width: 32, height: 32)
          .opacity(viewStore.inside ? 1 : 0)
        
        Image(viewStore.profileImage)
          .resizable()
          .frame(width: 30, height: 30)
      }
      .frame(width: 34, height: 35)
      .overlay(
        Image("insideFlag")
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
            if viewStore.type != 0 {
              Text("질문")
                .font(.body4)
                .foregroundColor(.green500)
            }
            
            HStack(alignment: .bottom) {
              Text(viewStore.receivedMessage)
                .font(.body4)
                .foregroundColor(viewStore.type == 0 ? Color.black : Color.white)
              
              if viewStore.type != 0 {
                Image("reply")
              }
            }
          }
          .padding([.top, .bottom], 9)
          .padding([.leading, .trailing], 14)
          .background(viewStore.type == 0 ? Color.white150 : Color.black)
          .cornerRadius(14, corners: [.topRight, .bottomLeft, .bottomRight])
          .frame(
            minWidth: 10,
            idealWidth: 266,
            maxWidth: 266,
            alignment: .topLeading
          )
        }
        
        
        Text("23:00")
          .font(.cap2)
          .foregroundColor(.white900)
      }
      
      Spacer()
    }
    .padding(.leading, 10)
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
