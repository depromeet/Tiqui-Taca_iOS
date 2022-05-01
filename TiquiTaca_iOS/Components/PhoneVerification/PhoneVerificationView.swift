//
//  PhoneVerificationView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/01.
//

import ComposableArchitecture
import SwiftUI

//struct NormalButtonStyle: ButtonStyle {
//  func makeBody(configuration: Configuration) -> some View {
//    configuration.label
//      .padding(.vertical, 20)
//      .frame(maxWidth: .infinity)
//      .font(.system(size: 14))
//      .foregroundColor(Color.white)
//      .background(Color.black)
//      .cornerRadius(6.0)
//  }
//}

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
      }
      .padding(20)
      .disabled(viewStore.isAvailablePhoneNumber)
    }
  }
}


extension String {
  func phoneNumberFormat() -> String {
    let str = self.replacingOccurrences(of: "-", with: "") // 하이픈 모두 빼준다
    let arr = Array(str)
    if arr.count > 3 {
      let prefix = String(format: "%@%@", String(arr[0]), String(arr[1]))
      if prefix == "02" { // 서울지역은 02번호
        if let regex = try? NSRegularExpression(pattern: "([0-9]{2})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
          let modString = regex.stringByReplacingMatches(
            in: str,
            options: [],
            range: NSRange(str.startIndex..., in: str),
            withTemplate: "$1-$2-$3"
          )
          return modString
        }
      } else if prefix == "15" || prefix == "16" || prefix == "18" { // 썩을 지능망...
        if let regex = try? NSRegularExpression(pattern: "([0-9]{4})([0-9]{4})", options: .caseInsensitive) {
          let modString = regex.stringByReplacingMatches(in: str, options: [], range: NSRange(str.startIndex..., in: str), withTemplate: "$1-$2")
          return modString
        }
      } else { // 나머지는 휴대폰번호 (010-xxxx-xxxx, 031-xxx-xxxx, 061-xxxx-xxxx 식이라 상관무)
        if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
          let modString = regex.stringByReplacingMatches(in: str, options: [], range: NSRange(str.startIndex..., in: str), withTemplate: "$1-$2-$3")
          return modString
        }
      }
    }
    return self
  }
}
