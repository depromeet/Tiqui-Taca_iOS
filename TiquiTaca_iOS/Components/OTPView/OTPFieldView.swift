//
//  OTPView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/30.
//

import SwiftUI
import ComposableArchitecture

struct OTPFieldView: View {
  let store: Store<OTPFieldState, OTPFieldAction>
  
//  @FocusState var test: Int = 0
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 10) {
        ForEach(Array(viewStore.fields.enumerated()), id: \.element.index) { index, model in
          TextField(
            "",
            text: viewStore.binding(
              get: \.fields[index].text,
              send: { .activeField(index: index, content: $0) }
            )
          )
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .frame(height: 50)
//          .focused(viewStore.focusedFieldIndex, equals: model.index)
//          .focused( equals: model.index)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                model.isHighlight ? Color.green : Color.red,
                lineWidth: 2
              )
          )
          .frame(width: 40)
        }
      }
    }
  }
}
