//
//  LocationCategoryListView.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/23.
//

import SwiftUI
import TTDesignSystemModule

struct LocationCategoryListView: View {
  private let categoryList = CategoryManager.shared.categoryList
  @Binding var selectedCategory: CategoryEntity
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: .spacingXS) {
        ForEach(categoryList) { category in
          Button {
            selectedCategory = category
          } label: {
            HStack(spacing: .spacingXXS) {
              if let imageUrl = category.imageUrl {
                AsyncImage(url: imageUrl) { image in
                  image.resizable()
                } placeholder: {
                  ProgressView()
                }
                .frame(width: 24, height: 24)
              }
              Text(category.name)
            }
            .padding(.horizontal, .spacingM)
          }
          .buttonStyle(TTButtonChipStyle(isSelected: category == selectedCategory))
          .disabled(category == selectedCategory)
        }
      }
      .padding(.horizontal, .spacingXL)
    }
  }
}

struct LocationCategoryListView_Previews: PreviewProvider {
  static var previews: some View {
    LocationCategoryListView(selectedCategory: .constant(.init()))
      .previewLayout(.sizeThatFits)
  }
}
