//
//  ChatDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//


import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct ChatDetailView: View {
  typealias State = ChatDetailState
  typealias Action = ChatDetailAction
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  var store: Store<State, Action>
  let title: String
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let currentRoom: RoomInfoEntity.Response
    let chatLogList: [ChatLogEntity.Response]
    
    init(state: State) {
      currentRoom = state.currentRoom
      chatLogList = state.chatLogList
    }
  }
  
  init(title: String, store: Store<State, Action>) {
    self.title = title
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
    
    configNaviBar()
    UITextView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    VStack(spacing: 0) {
      List {
        ForEach(viewStore.chatLogList) { chatlog in
          ChatMessageView(
            store: .init(
              initialState: .init(),
              reducer: chatMessageReducer,
              environment: ChatMessageEnvironment()
            )
          )
            .receivedBubble
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
      }
      .listStyle(.plain)
      
      InputMessageView(store: store)
    }
      .navigationBarBackButtonHidden(true)
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {
            self.presentationMode.wrappedValue.dismiss()
          }) {
            HStack(spacing: 10) {
              Image("arrowBack")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
              Text( title )
                .font(.subtitle2)
                .foregroundColor(.white)
            }
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          HStack(spacing: 0) {
            Button(action: { }) {
              Image("alarmOn")
                .resizable()
                .frame(width: 24, height: 24)
            }
            Button(action: { }) {
              Image("menu")
                .resizable()
                .frame(width: 24, height: 24)
            }
          }
        }
      })
      .onAppear {
        viewStore.send(.onAppear)
      }
      .onDisappear {
        viewStore.send(.onDisAppear)
      }
  }
  
  private func configNaviBar() {
    let standardAppearance = UINavigationBarAppearance()
    standardAppearance.configureWithTransparentBackground()
    
    standardAppearance.backgroundColor = Color.black800.uiColor.withAlphaComponent(0.95)
    standardAppearance.titleTextAttributes = [
      .foregroundColor: Color.white.uiColor,
      .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
    ]
    UINavigationBar.appearance().standardAppearance = standardAppearance
    UINavigationBar.appearance().compactAppearance = standardAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
    UINavigationBar.appearance().layoutMargins.left = 24
    UINavigationBar.appearance().layoutMargins.bottom = 10
  }
}

private struct InputMessageView: View {
  private let store: Store<ChatDetailState, ChatDetailAction>
  @State var typingMessage: String = ""
  @State var isQuestion: Bool = false
  
  init(store: Store<ChatDetailState, ChatDetailAction>) {
    self.store = store
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      Button(action: {
        isQuestion.toggle()
      }) {
        Text("질문")
          .font(.body3)
          .padding(.horizontal, 18)
          .padding(.vertical, 18)
          .foregroundColor(isQuestion ? Color.black900 : Color.black100)
          .background(isQuestion ? Color.green500 : Color.white300)
          .cornerRadius(40)
          .frame(height: 52)
      }
      
      HStack(alignment: .center, spacing: 4) {
        TextEditor(text: $typingMessage)
          .foregroundColor(Color.black900)
          .font(.body4)
          .background(
            ZStack {
              Text(
                typingMessage.isEmpty ?
                  "텍스트를 남겨주세요" : ""
              )
                .foregroundColor(Color.black100)
                .font(.body4)
                .padding(.leading, 4)
                .hLeading()
            }
          )
          .hLeading()
          .frame(alignment: .center)
          .onChange(of: typingMessage) {_ in
            if typingMessage.trimmingCharacters(in: .whitespacesAndNewlines)
              .isEmpty {
              typingMessage = ""
            }
          }
        
        VStack(spacing: 0) {
          Spacer()
            .frame(minHeight: 0, maxHeight: .infinity)
          Button(action: {
            if !typingMessage.isEmpty {
              let chat = SendChatEntity(
                inside: true,
                type: isQuestion ? 1 : 0,
                message: typingMessage
              )
              ViewStore(store).send(.sendMessage(chat))
              isQuestion = false
              typingMessage = ""
            }
          }) {
            Image("sendDisable")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(
                typingMessage.isEmpty ?
                  Color.black100 :
                  Color.green700
              )
              .frame(width: 24, height: 32)
          }
        }
      }
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .padding(0)
        .frame(height: 52)
        .background(Color.white150)
        .cornerRadius(16)
        .hLeading()
    }
      .padding(8)
      .background(Color.white50)
  }
}

//struct ChatDetailView_Previews: PreviewProvider {
//	static var previews: some View {
//		ChatDetailView()
//	}
//}
