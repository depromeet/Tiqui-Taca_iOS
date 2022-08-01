//
//  LocationCategory.swift
//  TiquiTaca_iOS
//
//  Created by 김록원 on 2022/08/01.
//

import Foundation

enum LocationCategory: String, Codable {
  case all = "ALL"
  case favorite = "FAVORITE"
  case university = "UNIVERSITY"
  case concerthall = "CONCERTHALL"
  case hanriverpark = "HANRIVERPRAK"
  case stadium = "STADIUM"
  case exhibition = "EXHIBITION"
  case amusementpark = "AMUSEMENTPARK"
  case departmentstore = "DEPARTMENTSTORE"
  
  var imageName: String {
    switch self {
    case .all:
      return ""
    case .favorite:
      return "category_favorite"
    case .university:
      return "category_university"
    case .concerthall:
      return "category_concerthall"
    case .hanriverpark:
      return "category_hanriverpark"
    case .stadium:
      return "category_stadium"
    case .exhibition:
      return "category_exhibition"
    case .amusementpark:
      return "category_amusementpark"
    case .departmentstore:
      return "category_departmentstore"
    }
  }
  
  var locationName: String {
    switch self {
    case .all:
      return "전체"
    case .favorite:
      return "즐겨찾기한 곳"
    case .university:
      return "대학교"
    case .concerthall:
      return "공연장"
    case .hanriverpark:
      return "한강공원"
    case .stadium:
      return "경기장"
    case .exhibition:
      return "전시장"
    case .amusementpark:
      return "놀이공원"
    case .departmentstore:
      return "백화점"
    }
  }
}

extension LocationCategory: CaseIterable, Identifiable {
  var id: Self { self }
}
