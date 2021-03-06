//
//  ChatDetailView.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/05/20.
//


import SwiftUI
import Combine
import ComposableArchitecture
import TTDesignSystemModule

struct ChatDetailView: View {
  typealias CDState = ChatDetailState
  typealias Action = ChatDetailAction
  
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Binding var shouldPopToRootView: Bool
  @State var scrollToBottomButtonHidden = false
  @State var showOtherProfile = false
  @State var showGuideView: Bool = false
  @State var inRadiusOpacity: Double = 1.0
  
  var store: Store<CDState, Action>
  var scrollMinY: CGFloat = 750
  
  struct ViewState: Equatable {
    let route: CDState.Route?
    let currentRoom: RoomInfoEntity.Response
    let chatLogList: [ChatLogEntity.Response]
    let blockUserList: [BlockUserEntity.Response]?
    let chatMenuState: ChatMenuState
    let myInfo: UserEntity.Response?
    let isFirstLoad: Bool
    let isWithinRadius: Bool
    let isAlarmOn: Bool
    let showLocationToast: Bool
    let focusMessageId: String?
    
    init(state: CDState) {
      route = state.route
      currentRoom = state.currentRoom
      chatLogList = state.chatLogList
      blockUserList = state.blockUserList
      chatMenuState = state.chatMenuState
      myInfo = state.myInfo
      isFirstLoad = state.isFirstLoad
      isWithinRadius = state.isWithinRadius
      isAlarmOn = state.isAlarmOn
      showLocationToast = state.showLocationToast
      focusMessageId = state.focusMessageId
    }
  }
  
  init(store: Store<ChatDetailState, ChatDetailAction>) {
    self.init(store: store, shouldPopToRootView: .constant(false))
  }
  
  init(store: Store<ChatDetailState, ChatDetailAction>, shouldPopToRootView: Binding<Bool>) {
    self._shouldPopToRootView = shouldPopToRootView
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))

    UITableView.appearance().tableHeaderView = UIView(frame: .zero)
    UITableView.appearance().sectionHeaderTopPadding = 0
    UITextView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollViewReader { scrollView in
        ScrollView {
          GeometryReader { proxy in
            Color.clear
              .preference(
                key: OffsetPreferenceKey.self,
                value: proxy.frame(in: .named("frameLayer")).minY
              )
          }
            .frame(height: 0)
          
          LazyVStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 4).background(.white).id("listBottom")
            ForEach(
              viewStore.chatLogList.reversed().enumerated().map({ $0 }),
              id: \.element.id
            ) { index, chatLog in
              switch chatLog.getChatMessageType(myId: viewStore.myInfo?.id) {
              case .date:
                ChatMessageView(chatLog: chatLog)
                  .dateBubble
                  .scaleEffect(x: 1, y: -1, anchor: .center)
                  .id(chatLog.id)
              case .sent:
                ChatMessageView(
                  chatLog: chatLog,
                  isTimeShow: messageTimeShow(idx: index)
                )
                  .sentBubble
                  .scaleEffect(x: 1, y: -1, anchor: .center)
                  .onTapGesture {
                    if chatLog.type == 1 {
                      viewStore.send(.selectQuestionDetail(chatLog.id ?? ""))
                    }
                  }
                  .id(chatLog.id)
              case .receive:
                ChatMessageView(
                  chatLog: chatLog,
                  isBlind: chatLog.isBlind(blockList: viewStore.blockUserList),
                  isProfileShow: messageProfileShow(idx: index),
                  isTimeShow: messageTimeShow(idx: index),
                  profileTapped: { log in
                    viewStore.send(.selectProfile(log.sender))
                    showOtherProfile = true
                  }
                )
                  .receivedBubble
                  .scaleEffect(x: 1, y: -1, anchor: .center)
                  .onTapGesture {
                    if chatLog.type == 1 && !chatLog.isBlind(blockList: viewStore.blockUserList) {
                      viewStore.send(.selectQuestionDetail(chatLog.id ?? ""))
                    }
                  }
                  .id(chatLog.id)
              }
            }
            Spacer().frame(height: 90).background(.white)
          }
          .onLoad {
            scrollView.scrollTo(viewStore.focusMessageId)
          }
        }
          .simultaneousGesture(
            TapGesture().onEnded({
              hideKeyboard()
            })
          )
          .scaleEffect(x: 1, y: -1, anchor: .center)
          .background(.white)
          .coordinateSpace(name: "frameLayer")
          .onPreferenceChange(
            OffsetPreferenceKey.self,
            perform: { y in
              scrollToBottomButtonHidden = y <= scrollMinY
            })
          .overlay(navigationView, alignment: .top)
          .overlay(
            Button {
              withAnimation { scrollView.scrollTo("listBottom", anchor: .bottom) }
            } label: {
              Image("rightArrow").resizable()
                .frame(width: 32, height: 32)
                .rotationEffect(.degrees(90))
                .padding([.bottom, .trailing], 16)
            }
              .opacity(scrollToBottomButtonHidden ? 0 : 1)
            ,
            alignment: .bottomTrailing
          )
          .popup(
            isPresented: viewStore.binding(
              get: \.showLocationToast,
              send: ChatDetailAction.setLocationToast
            ),
            type: .toast,
            position: .bottom,
            animation: .easeIn,
            autohideIn: 3,
            dragToDismiss: true,
            closeOnTap: true,
            closeOnTapOutside: true,
            backgroundColor: .clear
          ) {
            if viewStore.isWithinRadius {
              TTToastView(title: "현재 해당 스팟 위치에 들어와있습니다", type: .success)
            } else {
              TTToastView(title: "현재 해당 스팟 위치에서 벗어나있습니다", type: .blur)
            }
          }
      }
      
      NavigationLink(
        tag: CDState.Route.questionDetail,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          QuestionDetailView(
            store: store.scope(
              state: \.questionDetailViewState,
              action: ChatDetailAction.questionDetailAction
            )
          )
        },
        label: EmptyView.init
      )
        .frame(height: 0)
      
      NavigationLink(
        tag: CDState.Route.sendLetter,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          LetterSendView(
            store: store.scope(
              state: \.letterSendState,
              action: ChatDetailAction.letterSendAction
            )
          )
        },
        label: EmptyView.init
      )
      .frame(height: 0)
      
      InputChatView(store: store)
    }
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("")
      .navigationBarHidden(true)
      .ignoresSafeArea(.all, edges: .top)
      .overlay(
        OtherProfileView(
          store: store.scope(
            state: \.otherProfileState,
            action: ChatDetailAction.otherProfileAction
          ),
          showView: $showOtherProfile,
          sendLetter: { userInfo in
            viewStore.send(.selectSendLetter(userInfo))
          },
          actionHandler: { action in
            viewStore.send(.setOtherProfileAction(action))
          }
        )
          .opacity(showOtherProfile ? 1 : 0),
        alignment: .center
      )
      .popup(
        isPresented: $showGuideView,
        type: .default,
        dragToDismiss: false,
        closeOnTap: false,
        backgroundColor: Color.black800.opacity(0.7)
      ) {
        ChatGuideView(showGuideView: $showGuideView)
      }
      .onAppear {
        if viewStore.isFirstLoad && !UserDefaults.standard.bool(forKey: "hideGuidView") {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showGuideView = true
          }
        }
        
        viewStore.send(.onAppear)
      }
      .onDisappear {
        viewStore.send(.onDisAppear)
      }
  }
  
  private func messageProfileShow(idx: Int) -> Bool {
    let chatList: [ChatLogEntity.Response] = viewStore.chatLogList.reversed()
    let chat = chatList[idx]
    
    if idx + 1 == chatList.count {
      return true
    }
    
    let nextChat = chatList[idx + 1]
    if nextChat.type == 3 ||
        chat.sender?.id != nextChat.sender?.id ||
        chat.createdAt?.getTimeStringFromDateString() != nextChat.createdAt?.getTimeStringFromDateString() {
      return true
    } else {
      return false
    }
  }
  
  private func messageTimeShow(idx: Int) -> Bool {
    if idx == 0 { return true }
    let chatList: [ChatLogEntity.Response] = viewStore.chatLogList.reversed()
    let chat = chatList[idx]
    let preChat = chatList[idx - 1]
    
    if preChat.type == 3 ||
        chat.sender?.id != preChat.sender?.id ||
        chat.createdAt?.getTimeStringFromDateString() != preChat.createdAt?.getTimeStringFromDateString() {
      return true
    } else {
      return false
    }
  }
}

// MARK: Message Input View
private struct InputChatView: View {
  private let store: Store<ChatDetailState, ChatDetailAction>
  @ObservedObject private var viewStore: ViewStore<ViewState, ChatDetailAction>
  @State var typingMessage: String = ""
  @State var isQuestion: Bool = false
  @State var editorHeight: CGFloat = 32
  
  struct ViewState: Equatable {
    let isWithinRadius: Bool
    
    init(state: ChatDetailState) {
      isWithinRadius = state.isWithinRadius
    }
  }
  
  init(store: Store<ChatDetailState, ChatDetailAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
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
                inside: viewStore.isWithinRadius,
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

// MARK: Overlay View
extension ChatDetailView {
  var navigationView: some View {
    VStack {
      HStack {
        HStack(spacing: 10) {
          Button {
            self.presentationMode.wrappedValue.dismiss()
          } label: {
            Image("arrowBack")
              .renderingMode(.template)
              .resizable()
              .scaledToFit()
              .foregroundColor(.white)
              .frame(width: 24, height: 24)
          }
          Text( viewStore.state.currentRoom.viewTitle )
            .font(.subtitle2)
            .foregroundColor(.white)
          if viewStore.state.isWithinRadius {
            Circle()
              .frame(width: 8, height: 8, alignment: .center)
              .foregroundColor(.green800)
              .opacity(inRadiusOpacity)
              .onAppear {
                withAnimation(Animation.easeIn(duration: 0.7).repeatForever()) {
                  inRadiusOpacity = inRadiusOpacity == 1.0 ? 0 : 1
                }
              }
          }
        }
        
        Spacer()
        
        HStack(spacing: 12) {
          Button {
            viewStore.send(.selectAlarm)
          } label: {
            Image(viewStore.isAlarmOn ? "alarmOn" : "alarmOff")
              .resizable()
              .frame(width: 24, height: 24)
          }
          
          NavigationLink(
            tag: CDState.Route.menu,
            selection: viewStore.binding(
              get: \.route,
              send: Action.setRoute
            ),
            destination: {
              ChatMenuView(store: chatMenuStore, shouldPopToRootView: $shouldPopToRootView)
            },
            label: {
              Image("menu")
                .resizable()
                .frame(width: 24, height: 24)
            }
          )
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

// MARK: TextView Representable
struct UITextViewRepresentable: UIViewRepresentable {
  @Binding var text: String
  @Binding var inputHeight: CGFloat
  
  func makeUIView(context: UIViewRepresentableContext<UITextViewRepresentable>) -> UITextView {
    let textView = UITextView(frame: .zero)
    textView.backgroundColor = .clear
    textView.delegate = context.coordinator
    textView.font = UIFont(name: "Pretendard-Medium", size: 13)
    textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    textView.tintColor = Color.green900.uiColor
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

// MARK: OffsetPreference
private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
