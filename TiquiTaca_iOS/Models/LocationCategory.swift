//
//  CategoryType.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/22.
//

import Foundation

enum LocationCategory: String, Codable {
  case UNIVERSITY
  case EXHIBITION
  case HANRIVERPRAK
  
  var imageName: String {
    switch self {
    case .UNIVERSITY:
      return "category1"
    case .EXHIBITION:
      return "category2"
    case .HANRIVERPRAK:
      return "category3"
    }
  }
  
  var locationName: String {
    switch self {
    case .UNIVERSITY:
      return "대학교"
    case .EXHIBITION:
      return "전시회"
    case .HANRIVERPRAK:
      return "한강공원"
    }
  }
}
