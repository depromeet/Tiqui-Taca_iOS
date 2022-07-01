//
//  QuestionInputMessageView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/06/04.
//

import SwiftUI
import ComposableArchitecture

struct QuestionInputMessageView: View {
  let store: Store<QuestionInputMessageState, QuestionInputMessageAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .bottom, spacing: 8) {
        HStack(alignment: .center, spacing: 4) {
          TextEditor(
            text: viewStore.binding(
              get: \.inputMessage,
              send: QuestionInputMessageAction.messageTyping
            )
          )
          .foregroundColor(Color.black900)
          .font(.body4)
          .background(
            ZStack {
              Text(
                viewStore.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
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
          
          VStack(spacing: 0) {
            Spacer()
              .frame(minHeight: 0, maxHeight: .infinity)
            Button {
              if !viewStore.inputMessage.isEmpty {
                viewStore.send(.sendMessage)
              }
            } label: {
              Image("sendDisable")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(
                  viewStore.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
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
}

struct QuestionInputMessageView_Previews: PreviewProvider {
    static var previews: some View {
      QuestionInputMessageView(
        store: .init(
          initialState: .init(),
          reducer: questionInputMessageReducer,
          environment: QuestionInputMessageEnvironment()
        )
      )
    }
}
