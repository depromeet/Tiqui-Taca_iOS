//
//  MyPageItemInfo.swift
//  TiquiTaca_iOS
//
//  Created by 강민석 on 2022/05/27.
//

import Foundation

struct MyPageItemInfo: Equatable, Identifiable {
  let id: UUID = UUID()
  var itemType: MyPageItemType
  var description: String?
  var toggleVisible: Bool = false
  var imageName: String {
    switch itemType {
    case .myInfoView:
      return "myInfo"
    case .blockHistoryView:
      return "block"
    case .noticeView:
      return "info"
    case .myTermsOfServiceView:
      return "terms"
    case .csCenterView:
      return "center"
    case .alarmSet:
      return "alarm"
    case .versionInfo:
      return "version"
    case .levelInfo:
      return ""
    }
  }
  var title: String {
    switch itemType {
    case .myInfoView:
      return "내 정보"
    case .alarmSet:
      return "알림설정"
    case .blockHistoryView:
      return "차단 이력"
    case .noticeView:
      return "공지사항"
    case .myTermsOfServiceView:
      return "이용약관"
    case .csCenterView:
      return "고객센터"
    case .versionInfo:
      return "버전정보"
    case .levelInfo:
      return ""
    }
  }
}
