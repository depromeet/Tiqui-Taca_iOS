//
//  OTPView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/30.
//

import SwiftUI
import ComposableArchitecture

struct OTPFieldView: View {
  @FocusState var focusedFieldIndex: Int?
  let store: Store<OTPFieldState, OTPFieldAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .center, spacing: 8) {
        ForEach(viewStore.fields) { model in
          TextField(
            "",
            text: viewStore.binding(
              get: \.fields[model.id].text,
              send: { .activeField(index: model.id, content: $0) }
            )
          )
          .multilineTextAlignment(.center)
          .keyboardType(.numberPad)
          .focused($focusedFieldIndex, equals: model.id)
          .frame(width: 44, height: 56)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(model.isFilled ? Color.green : Color.white, lineWidth: 2)
          )
          .onChange(of: viewStore.focusedFieldIndex) {
            focusedFieldIndex = $0
          }
        }
      }
    }
  }
}
