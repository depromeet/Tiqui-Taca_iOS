//
//  CertificateCodeFieldView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/04/23.
//

import SwiftUI
import ComposableArchitecture

struct CertificateCodeField: Equatable, Hashable {
  var index: Int
  var isFilled: Bool = false
  var inputNumber: String
}

struct CertificateCodeFieldView: View {
  let store: Store<CertificateCodeState, CertificateCodeAction>
  @ObservedObject var viewStore: ViewStore<CertificateCodeState, CertificateCodeAction>
  
  @FocusState var activeField: CertificateCodeField?
  
  init(store: Store<CertificateCodeState, CertificateCodeAction>) {
    self.store = store
    viewStore = ViewStore(self.store)
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 10) {
        ForEach(viewStore.certificateCodeModels, id: \.index) { model in
          TextField("", text: viewStore.binding(
            get: \.certificateCodeModels[model.index].inputNumber,
            send: CertificateCodeAction.isTyping
          ))
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .frame(height: 50)
          .focused($activeField, equals: model)
          .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(model.isFilled ? .green : .gray.opacity(0.3), lineWidth: 2))
//                        .stroke(activeField == model ? .green : .gray.opacity(0.3), lineWidth: 2))
          .frame(width: 40)
        }
        .onChange(of: viewStore.certificateCodeModels) { newValue in
          certificateCodeCondition(value: newValue)
        }
      }
    }
  }
  
  func certificateCodeCondition(value: [CertificateCodeField]){
    
  }
}

struct CertificateCodeFieldView_Previews: PreviewProvider {
  static var previews: some View {
    CertificateCodeFieldView(
      store: Store(
        initialState: CertificateCodeState(
          certificateCodeModels: [
            .init(index: 0, inputNumber: ""),
            .init(index: 1, inputNumber: ""),
            .init(index: 2, inputNumber: ""),
            .init(index: 3, inputNumber: "")
          ]),
        reducer: certificateCodeReducer ,
        environment: CertificateCodeEnvironment()
      )
    )
  }
}
