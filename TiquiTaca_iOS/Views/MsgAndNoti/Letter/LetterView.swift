//
//  LetterView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/09.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct LetterView: View {
  typealias State = LetterState
  typealias Action = LetterAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  
  struct ViewState: Equatable {
    let letterSummaryList: [LetterSummaryEntity.Response]
    let route: State.Route?
    
    init(state: State) {
      letterSummaryList = state.letterSummaryList
      route = state.route
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if viewStore.letterSummaryList.isEmpty {
        VStack(alignment: .center) {
          Image("bxNoLetter")
            .resizable()
            .frame(width: 160, height: 160)
            .padding(.spacingM)
          Text("앗! 아직 다른 사람들과 주고 받은 쪽지가 없어요!")
            .font(.body2)
            .foregroundColor(.white900)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        List {
          ForEach(viewStore.letterSummaryList) { letter in
            Button {
              viewStore.send(.selectLetterDetail(letter))
            } label: {
              HStack {
                Image(letter.receiver?.profile.imageName ?? "defaultProfile")
                  .resizable()
                  .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 3) {
                  HStack {
                    Text(letter.receiver?.nickname ?? "")
                      .font(.body5)
                      .foregroundColor(.black900)
                    
                    Spacer()
                    Text(letter.latestTime?.getYearAndDate() ?? "")
                      .font(.cap1)
                      .foregroundColor(.white800)
                  }
                  Text(letter.latestMessage ?? "")
                    .font(.body4)
                    .foregroundColor(.black400)
                }
              }
            }
            .frame(height: 80)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .swipeActions(edge: .trailing) {
              Button(role: .destructive) {
                viewStore.send(.leaveLetter(letter.id ?? ""))
              } label: {
                Label("삭제", systemImage: "")
                  .font(.subtitle3)
                  .foregroundColor(.white50)
              }
            }
          }
        }
        .listStyle(.plain)
        .ignoresSafeArea()
      }
      NavigationLink(
        tag: State.Route.letterDetail,
        selection: viewStore.binding(
          get: \.route,
          send: Action.setRoute
        ),
        destination: {
          LetterDetailView(
            store: store.scope(
              state: \.letterDetailViewState,
              action: LetterAction.letterDetailView
            )
          )
        },
        label: EmptyView.init
      )
    }
    .onAppear {
      viewStore.send(.getLetterList)
    }
  }
}

struct LetterView_Previews: PreviewProvider {
  static var previews: some View {
    LetterView(
      store: .init(
        initialState: .init(),
        reducer: letterReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main
        )
      )
    )
  }
}
