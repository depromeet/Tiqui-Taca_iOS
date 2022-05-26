//
//  LocationCategoryListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/23.
//

import SwiftUI

struct LocationCategoryListView: View {
  @Binding var selectedCategory: LocationCategory
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: .spacingXS) {
        ForEach(LocationCategory.allCases) { category in
          Button {
          } label: {
            HStack(spacing: .spacingXXS) {
              if !category.imageName.isEmpty {
                Image(category.imageName)
                  .resizable()
                  .frame(width: 24, height: 24)
              }
              Text(category.locationName)
                .font(.body6)
                .foregroundColor(.white)
            }
            .padding(.leading, .spacingXS)
            .padding(.trailing, .spacingM)
            .frame(height: 32)
            .background(Color.black800)
            .cornerRadius(20)
          }
        }
      }
      .padding(.horizontal, .spacingXL)
    }
  }
}

struct LocationCategoryListView_Previews: PreviewProvider {
  static var previews: some View {
    LocationCategoryListView(selectedCategory: .constant(.all))
  }
}
