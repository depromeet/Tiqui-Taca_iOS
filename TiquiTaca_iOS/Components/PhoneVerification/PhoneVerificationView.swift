//
//  PhoneVerificationView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import SwiftUI

struct PhoneVerificationView: View {
  let store: Store<PhoneVerificationState, PhoneVerificationAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      TextField(
        "휴대폰 번호를 입력해주세요.",
        text: viewStore.binding(
          get: { $0.phoneNumber.phoneNumberFormat() },
          send: PhoneVerificationAction.phoneNumberInput
        )
      )
      .keyboardType(.numberPad)
      .padding(.top, 40)
      
      Button {
        viewStore.send(.verificationButtonTap)
      } label: {
        Text("인증 번호 요청하기")
          .padding(.vertical, 20)
          .frame(maxWidth: .infinity)
          .font(.system(size: 14))
          .foregroundColor(Color.white)
          .background(Color.gray)
          .cornerRadius(6.0)
      }
      .padding(20)
      .disabled(viewStore.isAvailablePhoneNumber)
    }
  }
}

// 임시 extension (PhoneNumberKit 고려)
extension String {
  func phoneNumberFormat() -> String {
    let str = self.replacingOccurrences(of: "-", with: "")
    let arr = Array(str)
    if arr.count > 3 {
      if let regex = try? NSRegularExpression(
        pattern: "([0-9]{3})([0-9]{4})([0-9]{4})",
        options: .caseInsensitive
      ) {
        let modString = regex.stringByReplacingMatches(
          in: str,
          options: [],
          range: NSRange(str.startIndex..., in: str),
          withTemplate: "$1-$2-$3"
        )
        return modString
      }
    }
    return self
  }
}
