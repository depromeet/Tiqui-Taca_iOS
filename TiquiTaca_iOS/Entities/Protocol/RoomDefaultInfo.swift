//
//  RoomDefaultInfo.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/06/01.
//

import Foundation

protocol RoomDefaultInfo {
  var id: String { get }
  var name: String { get }
  var category: CategoryEntity? { get }
}
