//
//  QuestionItemView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import SwiftUI

struct QuestionItemView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image("defaultProfile")
          .resizable()
          .frame(width: 32, height: 32)
        
        VStack(alignment: .leading) {
          Text("안녕하세요")
            .font(.body4)
            .foregroundColor(.black900)
          Text("1시간 전")
            .font(.body8)
            .foregroundColor(.white800)
        }
        
        Spacer()
        Image("right_arrow")
      }
      
      VStack {
        Text("안녕하세여 ㅎㅅㅎ")
          .font(.body3)
          .foregroundColor(.black900)
        HStack {
          Button {
            
          } label: {
            Image("reply_good_on")
            Text("0")
              .font(.body7)
              .foregroundColor(.white800)
          }
          
          Button {
            
          } label: {
            Image("question_reply")
            Text("0")
              .font(.body7)
              .foregroundColor(.white800)
          }
          
        }
      }
      
    }
    .padding(.top, 10)
    .padding([.leading, .trailing], 12)
    .padding(.bottom, 16)
    .background(Color.white100)
  }
}

struct QuestionItemView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionItemView()
  }
}
