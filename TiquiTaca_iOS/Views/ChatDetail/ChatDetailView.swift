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
  var store: Store<State, Action>
  
  struct ViewState: Equatable {
    let currentRoom: RoomInfoEntity.Response
    let chatLogList: [ChatLogEntity.Response]
        let chatMenuState: ChatMenuState
    
    init(state: State) {
      currentRoom = state.currentRoom
      chatLogList = state.chatLogList
            chatMenuState = state.chatMenuState
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))

    UITableView.appearance().tableHeaderView = UIView(frame: .zero)
    UITableView.appearance().sectionHeaderTopPadding = 0
    UITextView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack(alignment: .top) {
        List {
          Section(
            footer: VStack{}.frame(height: 80).background(.white).padding(0)
          ) {
            ForEach(viewStore.chatLogList.reversed()) { chatLog in
              ChatMessageView(chatLog: chatLog)
                .receivedBubble
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .scaleEffect(x: 1, y: -1, anchor: .center)
            }
          }
        }
        .listStyle(.plain)
        .gesture(
          DragGesture().onChanged({_ in
            hideKeyboard()
          })
        )
        .scaleEffect(x: 1, y: -1, anchor: .center)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: -44, trailing: 0))
        .background(.white)
        
        navigationView
      }
      
      InputChatView(store: store)
    }
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
      .ignoresSafeArea(.container, edges: .top)
      .onAppear {
        viewStore.send(.onAppear)
      }
      .onDisappear {
        viewStore.send(.onDisAppear)
      }
  }
  
//  private func configNaviBar() {
//    let standardAppearance = UINavigationBarAppearance()
//    standardAppearance.configureWithTransparentBackground()
//
//    standardAppearance.backgroundColor = Color.black800.uiColor.withAlphaComponent(0.95)
//    standardAppearance.titleTextAttributes = [
//      .foregroundColor: Color.white.uiColor,
//      .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
//    ]
//
//    UINavigationBar.appearance().standardAppearance = standardAppearance
//    UINavigationBar.appearance().compactAppearance = standardAppearance
//    UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
//    UINavigationBar.appearance().layoutMargins.left = 24
//    UINavigationBar.appearance().layoutMargins.bottom = 10
//  }
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

struct ChatDetailView_Previews: PreviewProvider {
  static var previews: some View {
    ChatDetailView(
      store: .init(
        initialState: .init(),
        reducer: chatDetailReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}

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
          Button {
          } label: {
            Image("menu")
              .resizable()
              .frame(width: 24, height: 24)
          }
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
