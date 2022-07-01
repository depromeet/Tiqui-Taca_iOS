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
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top, spacing: 0) {
        Image(model.user.profile.imageName)
          .resizable()
          .frame(width: 32, height: 32)
          .padding(.trailing, 8)
        
        VStack(alignment: .leading) {
          Text(
            model.user.status == UserStatus.forbidden ? "(이용제한 사용자)" : model.user.nickname
          )
            .font(.body4)
            .foregroundColor(
              model.user.status == UserStatus.normal ? .black900 :.black50
            )
          Text(model.createdAt.getTimeTodayOrDate())
            .font(.body8)
            .foregroundColor(.white800)
        }
        Spacer()
        Image("arrowForward")
          .resizable()
          .frame(width: 24, height: 24)
      }
      
      VStack(alignment: .leading, spacing: 4) {
        Text(model.content)
          .font(.body3)
          .foregroundColor(.black900)
          .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
        
        HStack(spacing: 0) {
          Image(model.ilike ? "replyGoodOn" : "replyGoodOff")
          Text("\(model.likesCount)")
            .font(.body7)
            .foregroundColor(.white800)
            .padding(.leading, 2)
            .padding(.trailing, 10)
          
          Image("comments")
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(model.commentsCount)")
            .font(.body7)
            .foregroundColor(.white800)
            .padding(.leading, 2)
        }
      }
      .padding(.top, 8)
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
//    QuestionItemView(model: .init()
////    QuestionItemView()
//  }
//}
