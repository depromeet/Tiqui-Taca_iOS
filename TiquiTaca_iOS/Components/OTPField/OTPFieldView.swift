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
  @State var typingText: String = ""
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack(alignment: .center) {
        TextField("", text: $typingText, onEditingChanged: { _ in })
          .foregroundColor(.clear)
          .font(.heading2)
          .keyboardType(.numberPad)
          .accentColor(.clear)
          .focused($focusedFieldIndex, equals: 0)
          .onChange(of: typingText) {_ in
            if typingText.count > 4 {
              typingText = String(typingText.dropLast())
            } else if typingText.count == 4 {
              viewStore.send(.lastFieldTrigger(typingText))
            }
          }
        
        HStack(spacing: 8) {
          ForEach(0..<4) { idx in
            Text(
              typingText.count > idx ?
              String(typingText[typingText.index(typingText.startIndex, offsetBy: idx)]) :
                ""
            )
            .font(.heading2)
            .foregroundColor(.green600)
            .frame(width: 44, height: 56)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(typingText.count > idx ? Color.green600 : Color.white50, lineWidth: .spacingXXXS)
            )
          }
        }
      }
      .frame(height: 56)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          focusedFieldIndex = 0
        }
      }
    }
  }
}
