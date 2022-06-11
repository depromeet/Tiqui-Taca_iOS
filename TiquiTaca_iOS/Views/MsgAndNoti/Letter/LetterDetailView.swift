//
//  LetterDetailView.swift
//  TiquiTaca_iOS
//
//  Created by hakyung on 2022/06/10.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct LetterDetailView: View {
  typealias State = LetterDetailState
  typealias Action = LetterDetailAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  struct ViewState: Equatable {
    let route: State.Route?
    let letterRoomId: String
    let letterSender: UserEntity.Response?
    let letterList: [LetterEntity.Response]
    let letterSendViewState: LetterSendState
    let loginUserId: String
    
    init(state: State) {
      route = state.route
      letterRoomId = state.letterRoomId
      letterSender = state.letterSender
      letterList = state.letterList
      letterSendViewState = state.letterSendViewState
      loginUserId = state.loginUserId
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      topNavigationView
      
      List {
        ForEach(viewStore.letterList) { letter in
          HStack {
            Image(letter.sender?.profile.imageName ?? "defaultProfile")
              .resizable()
              .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 3) {
              HStack {
                Text((letter.sender?.id == viewStore.loginUserId ?
                      "나(\(letter.sender?.nickname ?? ""))" : letter.sender?.nickname) ?? "")
                  .font(.body5)
                  .foregroundColor(.black900)
                
                Spacer()
                Text(letter.createdAt?.getYearAndDate() ?? "")
                  .font(.cap1)
                  .foregroundColor(.white800)
              }
              Text(letter.message ?? "")
                .multilineTextAlignment(.leading)
                .font(.body4)
                .foregroundColor(.black400)
            }
          }
//          .frame(height: 80)
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
      }
      .listStyle(.plain)
      
      Button {
        viewStore.send(.setRoute(.sendLetter))
      } label: {
        Text("쪽지 보내기")
      }
      .buttonStyle(TTButtonLargeBlackStyle())
      .padding([.leading, .trailing], 24)
      
      NavigationLink(
        tag: State.Route.sendLetter,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          LetterSendView(
            store: store.scope(
              state: \.letterSendViewState,
              action: LetterDetailAction.letterSendView
            )
          )
        },
        label: EmptyView.init
      )
    }
    .navigationBarHidden(true)
    .ignoresSafeArea(.all, edges: .top)
    .onAppear {
      viewStore.send(.onAppear)
    }
  }
  
  var topNavigationView: some View {
    VStack {
      HStack {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("arrowBack")
            .resizable()
            .frame(width: 24, height: 24)
        }
        
        Spacer()
        Text(viewStore.letterSender?.nickname ?? "")
          .font(.subtitle2)
          .foregroundColor(.black800)
        
        Spacer()
        
        HStack {
        }
        .frame(width: 24)
      }
      .padding([.leading, .trailing], 10)
      .padding(.top, 54)
      .padding(.bottom, 10)
    }
    .background(Color.white)
    .frame(height: 88)
  }
}

struct LetterDetailView_Previews: PreviewProvider {
  static var previews: some View {
    LetterDetailView(
      store: .init(
        initialState: .init(letterRoomId: "", letterSender: nil),
        reducer: letterDetailReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
