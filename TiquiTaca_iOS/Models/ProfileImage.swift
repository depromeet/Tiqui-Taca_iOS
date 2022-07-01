//
//  ProfileImage.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/24.
//

import Foundation

struct ProfileImage: Equatable, Codable {
  /// Type Range: 1 ~ 30
  var type: Int = 1
  
  var imageName: String {
    return "profile\(type)"
  }
}
