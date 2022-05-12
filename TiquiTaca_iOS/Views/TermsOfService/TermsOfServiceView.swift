//
//  TermsOfServiceView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/17.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct TermsOfServiceView: View {
  typealias State = TermsOfServiceState
  typealias Action = TermsOfServiceAction
  
  private let store: Store<State, Action>
  @ObservedObject private var viewStore: ViewStore<ViewState, Action>
  @Environment(\.presentationMode) var presentationMode
  
  struct ViewState: Equatable {
    let route: State.Route?
    var tosFieldListState: TOSFieldListViewState
    
    init(state: State) {
      route = state.route
      tosFieldListState = state.tosFieldListState
    }
  }
  
  init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  var body: some View {
    VStack {
      Spacer()
      VStack(spacing: 50) {
        VStack(alignment: .leading, spacing: .spacingM) {
          Image("agreement")
          Text("티키타카가 처음이시네요\n이용약관에 동의해주세요!")
            .foregroundColor(.white)
            .font(.heading1)
          Text("원활한 서비스 이용을 위해 이용 약관 및 개인정보와 위치 정보 수집 동의가 필요해요.")
            .foregroundColor(.white600)
            .font(.body8)
        }
        .hLeading()
        
        VStack(spacing: .spacingM) {
          Button {
            viewStore.send(.tosFieldListAction(.allCheck))
          } label: {
            HStack(spacing: .spacingXS) {
              Image(systemName: "checkmark.circle.fill")
              Text("전체 동의하기")
              Spacer()
            }
            .padding(.horizontal, .spacingS)
          }
          .buttonStyle(
            TTButtonHighlightStyle(
              isHighlighted: viewStore.tosFieldListState.isAllCheckDone
            )
          )
          
          TOSFieldListView(store: tosFieldListStore)
        }
        
        Spacer()
        
        NavigationLink(
          tag: State.Route.createProfile,
          selection: viewStore.binding(
            get: \.route,
            send: Action.setRoute
          ),
          destination: {
            IfLetStore(
              createProfileStore,
              then: CreateProfileView.init
            )
          },
          label: {
            Button {
              viewStore.send(.setRoute(.createProfile))
            } label: {
              Text("동의하고 시작하기")
            }
            .buttonStyle(TTButtonLargeGreenStyle())
          }
        )
        .disabled(!viewStore.tosFieldListState.isAllRequiredCheckDone)
      }
      .padding(.horizontal, .spacingXL)
    }
    .vCenter()
    .background(Color.black800)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Image("leftArrow")
        }
      }
    }
  }
}

// MARK: - Store init
extension TermsOfServiceView {
  private var createProfileStore: Store<CreateProfileState?, CreateProfileAction> {
    return store.scope(
      state: \.createProfileState,
      action: Action.createProfileAction
    )
  }
  
  private var tosFieldListStore: Store<TOSFieldListViewState, TOSFieldListViewAction> {
    return store.scope(
      state: \.tosFieldListState,
      action: Action.tosFieldListAction
    )
  }
}

// MARK: - Preview
struct TermsOfServiceView_Previews: PreviewProvider {
  static var previews: some View {
    TermsOfServiceView(
      store: Store(
        initialState: .init(),
        reducer: termsOfServiceReducer,
        environment: .init(
          appService: .init(),
          mainQueue: .main)
      )
    )
  }
}
