//
//  TermsOfServiceCheckField.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/20.
//

import SwiftUI

struct TermsOfServiceCheckField: View {
  let title: String
  let isRequired: Bool
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Button {
        print("check button")
      } label: {
        Image(systemName: "checkmark")
      }
      
      HStack(alignment: .center, spacing: 0) {
        Text(isRequired ? "[필수]" : "[선택]")
        Text(title)
      }
      
      Spacer()
      
      Button {
        print("see detail")
      } label: {
        Text("보기")
          .underline()
      }
    }
    .font(.system(size: 13))
  }
}

struct TermsOfServiceCheckField_Previews: PreviewProvider {
  static var previews: some View {
    TermsOfServiceCheckField(title: "test", isRequired: true)
    TermsOfServiceCheckField(title: "test", isRequired: false)
  }
}
