//
//  QuestionItemView.swift
//  TiquiTaca_iOS
//
//  Created by 송하경 on 2022/05/28.
//

import SwiftUI
import ComposableArchitecture
import TTDesignSystemModule

struct QuestionItemView: View {
  var model: QuestionEntity.Response

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Image(model.user?.profile.imageName ?? "defaultProfile")
          .resizable()
          .frame(width: 32, height: 32)
        
        VStack(alignment: .leading) {
          Text(model.user?.nickname ?? "")
            .font(.body4)
            .foregroundColor(.black900)
          Text("1시간 전")
            .font(.body8)
            .foregroundColor(.white800)
        }
        
        Spacer()
        Image("arrowForward")
          .resizable()
          .frame(width: 24, height: 24)
      }
      
      VStack(alignment: .leading) {
        Text(model.content)
          .font(.body3)
          .foregroundColor(.black900)
        
        HStack {
          Image(model.ilike ? "replyGoodOn" : "replyGoodOff")
          Text("\(model.likesCount)")
            .font(.body7)
            .foregroundColor(.white800)
          
          Image("comments")
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(model.commentsCount)")
            .font(.body7)
            .foregroundColor(.white800)
        }
      }
    }
    .padding(.top, 10)
    .padding([.leading, .trailing], 12)
    .padding(.bottom, 16)
    .background(Color.white100)
    .cornerRadius(14)
  }
}

//struct QuestionItemView_Previews: PreviewProvider {
//  static var previews: some View {
////    QuestionItemView(model: QuestionEntity.Response.)
//  }
//}
