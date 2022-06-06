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
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Binding var shouldPopToRootView: Bool
  var store: Store<State, Action>
  var logListbottomPadding: Int {
    if #available(iOS 15.4, *) {
      return 0
    } else {
      return -44
    }
  }
  
  struct ViewState: Equatable {
    let currentRoom: RoomInfoEntity.Response
    let chatLogList: [ChatLogEntity.Response]
    let chatMenuState: ChatMenuState
    let myInfo: UserEntity.Response?
    
    init(state: State) {
      currentRoom = state.currentRoom
      chatLogList = state.chatLogList
      chatMenuState = state.chatMenuState
      myInfo = state.myInfo
    }
  }
  
  init(store: Store<State, Action>, shouldPopToRootView: Binding<Bool>) {
    self._shouldPopToRootView = shouldPopToRootView
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))

    UITableView.appearance().tableHeaderView = UIView(frame: .zero)
    UITableView.appearance().sectionHeaderTopPadding = 0
    UITextView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    VStack(spacing: 0) {
      List {
        Section(
          footer: Spacer().frame(height: 80).background(.white)
        ) {
          LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(viewStore.chatLogList.reversed(), id: \.id) { chatLog in
              if viewStore.myInfo?.id == chatLog.sender?.id {
                ChatMessageView(chatLog: chatLog)
                  .sentBubble
                  .scaleEffect(x: 1, y: -1, anchor: .center)
              } else {
                ChatMessageView(chatLog: chatLog)
                  .receivedBubble
                  .scaleEffect(x: 1, y: -1, anchor: .center)
              }
            }
          }
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets())
        }
      }
      
      .listStyle(.plain)
      .gesture(
        DragGesture().onChanged({_ in
          hideKeyboard()
        })
      )
      .scaleEffect(x: 1, y: -1, anchor: .center)
      .padding( EdgeInsets(top: 0, leading: 0, bottom: CGFloat(logListbottomPadding), trailing: 0) )
      .background(.white)
      .overlay(navigationView, alignment: .top)
      
      InputChatView(store: store)
    }
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("")
      .navigationBarHidden(true)
      .ignoresSafeArea(.all, edges: .top)
      .onAppear {
        viewStore.send(.onAppear)
      }
      .onDisappear {
        viewStore.send(.onDisAppear)
      }
  }
}

private struct InputChatView: View {
  private let store: Store<ChatDetailState, ChatDetailAction>
  @State var typingMessage: String = ""
  @State var isQuestion: Bool = false
  @State var editorHeight: CGFloat = 32
  
  init(store: Store<ChatDetailState, ChatDetailAction>) {
    self.store = store
  }
  
  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      Button {
        isQuestion.toggle()
      } label: {
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
        UITextViewRepresentable(text: $typingMessage, inputHeight: $editorHeight)
          .foregroundColor(Color.black900)
          .hLeading()
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
          .onChange(of: typingMessage) {_ in
            if typingMessage.trimmingCharacters(in: .whitespacesAndNewlines)
              .isEmpty {
              typingMessage = ""
            }
          }
        
        VStack(spacing: 0) {
          Spacer()
            .frame(minHeight: 0, maxHeight: .infinity)
          Button {
            if !typingMessage.isEmpty {
              let chat = SendChatEntity(
                inside: true,
                type: isQuestion ? 1 : 0,
                message: typingMessage
              )
              ViewStore(store).send(.sendMessage(chat))
              isQuestion = false
              typingMessage = ""
              editorHeight = 32
            }
          } label: {
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
        .frame(height: 20 + editorHeight)
        .background(Color.white150)
        .cornerRadius(16)
        .hLeading()
    }
    .padding(8)
    .background(Color.white50)
  }
}

// MARK: - Store init
extension ChatDetailView {
  private var chatMenuStore: Store<ChatMenuState, ChatMenuAction> {
    return store.scope(
      state: \.chatMenuState,
      action: Action.chatMenuAction
    )
  }
}

//struct ChatDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    ChatDetailView(
//      store: .init(
//        initialState: .init(),
//        reducer: chatDetailReducer,
//        environment: .init(
//          appService: .init(),
//          mainQueue: .main
//        )
//      )
//    )
//  }
//}

extension ChatDetailView {
  var navigationView: some View {
    VStack {
      HStack {
        Button {
          self.presentationMode.wrappedValue.dismiss()
        } label: {
          HStack(spacing: 10) {
            Image("arrowBack")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(.white)
              .frame(width: 24, height: 24)
            Text( viewStore.state.currentRoom.viewTitle )
              .font(.subtitle2)
              .foregroundColor(.white)
          }
        }
        
        Spacer()
        
        HStack(spacing: 4) {
          Button {
          } label: {
            Image("alarmOn")
              .resizable()
              .frame(width: 24, height: 24)
          }
          NavigationLink {
            ChatMenuView(store: chatMenuStore, shouldPopToRootView: $shouldPopToRootView)
          } label: {
            Image("menu")
              .resizable()
              .frame(width: 24, height: 24)
          }
          .isDetailLink(false)
        }
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.black800.opacity(0.95))
    .frame(height: 88)
  }
}


struct UITextViewRepresentable: UIViewRepresentable {
  @Binding var text: String
  @Binding var inputHeight: CGFloat
  
  func makeUIView(context: UIViewRepresentableContext<UITextViewRepresentable>) -> UITextView {
    let textView = UITextView(frame: .zero)
    textView.backgroundColor = .clear
    textView.delegate = context.coordinator
    textView.font = UIFont(name: "Pretendard-Medium", size: 13)
    textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    return textView
  }
  
  func makeCoordinator() -> UITextViewRepresentable.Coordinator {
    Coordinator(text: self.$text, inputHeight: $inputHeight)
  }
  
  func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewRepresentable>) {
    uiView.text = self.text
  }
  
  class Coordinator: NSObject, UITextViewDelegate {
    @Binding var text: String
    @Binding var inputHeight: CGFloat
    
    let maxHeight: CGFloat = 100
    
    init(text: Binding<String>, inputHeight: Binding<CGFloat>) {
      self._text = text
      self._inputHeight = inputHeight
    }
    
    func textViewDidChange(_ textView: UITextView) {
      let spacing = textView.font?.lineHeight ?? 0
      if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        textView.text = ""
        self.text = ""
        inputHeight = 32
        return
      }
      
      self.text = textView.text
      inputHeight = max(32, min(textView.contentSize.height, spacing * 5))
    }
  }
}


//struct ChatDetailView_Previews: PreviewProvider {
//	static var previews: some View {
//		ChatDetailView()
//	}
//}
