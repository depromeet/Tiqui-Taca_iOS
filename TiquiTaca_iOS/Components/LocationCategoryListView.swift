//
//  LocationCategoryListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/23.
//

import SwiftUI
import TTDesignSystemModule

struct LocationCategoryListView: View {
  @Binding var selectedCategory: LocationCategory
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: .spacingXS) {
        ForEach(LocationCategory.allCases) { category in
          Button {
            selectedCategory = category
          } label: {
            HStack(spacing: .spacingXXS) {
              if !category.imageName.isEmpty {
                Image(category.imageName)
                  .resizable()
                  .frame(width: 24, height: 24)
              }
              Text(category.locationName)
            }
            .padding(.horizontal, .spacingM)
          }
          .buttonStyle(TTButtonChipStyle(isSelected: category == selectedCategory))
          .disabled(category == selectedCategory)
        }
      }
      .padding(.horizontal, .spacingXL)
      .frame(height: 33)
    }
  }
}

struct LocationCategoryListView_Previews: PreviewProvider {
  static var previews: some View {
    LocationCategoryListView(selectedCategory: .constant(.all))
      .previewLayout(.sizeThatFits)
  }
}
