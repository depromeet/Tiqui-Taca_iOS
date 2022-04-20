//
//  TermsOfServiceView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/04/17.
//

import SwiftUI

struct TermsOfServiceView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 44) {
      VStack(alignment: .leading, spacing: 16) {
        Image(systemName: "questionmark.app.fill")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 58, height: 58)
        Text("티키타카가 처음이시네요\n이용약관에 동의해주세요!")
          .font(.system(size: 24))
        Text("원활한 서비스 이용을 위해 이용 약관 및 개인정보와 위치 정보 수집 동의가 필요해요.")
          .font(.system(size: 11))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        print("all agree button")
      } label: {
        HStack {
          Image(systemName: "checkmark.circle.fill")
          Text("전체 동의하기")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)
        .background(Color.gray)
        .foregroundColor(Color.white)
        .font(.system(size: 16, weight: .bold, design: .default))
        .cornerRadius(12)
      }
      
      VStack(alignment: .center, spacing: 19) {
        TermsOfServiceCheckField(title: "서비스 이용약관 동의", isRequired: true)
        TermsOfServiceCheckField(title: "개인정보 수집 및 이용 동의", isRequired: true)
        TermsOfServiceCheckField(title: "마케팅 SNS 알림 동의", isRequired: false)
      }
      .frame(maxWidth: .infinity)
      
      Spacer()
      
      Button {
        print("start button")
      } label: {
        Text("동의하고 시작하기")
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color.gray)
          .foregroundColor(Color.white)
          .font(.system(size: 16, weight: .bold, design: .default))
          .cornerRadius(16)
      }
    }
    .padding(EdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 23))
  }
}

struct TermsOfServiceView_Previews: PreviewProvider {
  static var previews: some View {
    TermsOfServiceView()
  }
}
