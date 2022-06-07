//
//  MyPageItemType.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/27.
//

import Foundation

enum MyPageItemType: Equatable, Identifiable {
  var id: Self { self }
  case myInfoView
  case alarmSet
  case blockHistoryView
  case noticeView
  case myTermsOfServiceView
  case csCenterView
  case versionInfo
  case levelInfo
}
